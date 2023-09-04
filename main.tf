###############################################
# Private Service Connect Producer - Mongo DB #
###############################################
data "mongodbatlas_project" "isv_mongodbatlast_project" {
  name = var.atlas_project_name
}

resource "mongodbatlas_privatelink_endpoint" "isv_mongodbatlas_pvtlink_endpoint" {
  project_id    = var.atlas_project_id
  provider_name = "GCP"
  region        = var.atlas_region
}

###############################################
# Private Service Connect Consumer - Mongo DB #
###############################################
data "google_compute_network" "vpc_compute_network" {
  project  = var.gcp_project_id_1
  name     = "default"
  provider = google.acc1
}

# MongoDB PSC needs 50 addresses in each region.
resource "google_compute_address" "compute_address_mongo" {
  provider     = google.acc1
  count        = var.psc_ip_count
  project      = var.gcp_project_id_1
  name         = "tf-test${count.index}"
  subnetwork   = data.google_compute_network.vpc_compute_network.id
  address_type = "INTERNAL"
  address      = "10.156.1.${count.index}"
  region       = var.gcp_region
}


# MongoDB PSC needs 50 forwarding rules with the above addresses in each region.
resource "google_compute_forwarding_rule" "compute_forwarding_rule_mongo" {
  provider                = google.acc1
  count                   = var.psc_ip_count
  target                  = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.service_attachment_names[count.index]
  project                 = google_compute_address.compute_address_mongo[count.index].project
  region                  = google_compute_address.compute_address_mongo[count.index].region
  name                    = google_compute_address.compute_address_mongo[count.index].name
  ip_address              = google_compute_address.compute_address_mongo[count.index].id
  network                 = data.google_compute_network.vpc_compute_network.id
  load_balancing_scheme   = ""
  allow_psc_global_access = true
}
resource "mongodbatlas_privatelink_endpoint_service" "isv_mongodbatlas_pvtlink_endpoint_service" {
  project_id          = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.project_id
  private_link_id     = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.private_link_id
  provider_name       = "GCP"
  endpoint_service_id = data.google_compute_network.vpc_compute_network.name
  # endpoint_service_id = data.google_compute_network.vpc_compute_network.name
  gcp_project_id = var.gcp_project_id_1

  dynamic "endpoints" {
    for_each = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.service_attachment_names
    content {
      ip_address    = google_compute_address.compute_address_mongo[endpoints.key].address
      endpoint_name = google_compute_forwarding_rule.compute_forwarding_rule_mongo[endpoints.key].name
    }
  }
}

# MongoDB PSC needs 50 addresses for another PSC in the region.
data "google_compute_network" "vpc_compute_network2" {
  project  = var.gcp_project_id_2
  name     = "default"
  provider = google.acc2
}
resource "google_compute_address" "compute_address_mongo-2" {
  provider     = google.acc2
  count        = var.psc_ip_count
  project      = var.gcp_project_id_2
  name         = "tf-test2${count.index}"
  subnetwork   = data.google_compute_network.vpc_compute_network2.id
  address_type = "INTERNAL"
  address      = "10.156.2.${count.index}"
  region       = var.gcp_region
}
resource "google_compute_forwarding_rule" "compute_forwarding_rule_mongo-2" {
  provider                = google.acc2
  count                   = var.psc_ip_count
  target                  = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.service_attachment_names[count.index]
  project                 = google_compute_address.compute_address_mongo-2[count.index].project
  region                  = google_compute_address.compute_address_mongo-2[count.index].region
  name                    = google_compute_address.compute_address_mongo-2[count.index].name
  ip_address              = google_compute_address.compute_address_mongo-2[count.index].id
  network                 = data.google_compute_network.vpc_compute_network2.id
  load_balancing_scheme   = ""
  allow_psc_global_access = true
}
resource "mongodbatlas_privatelink_endpoint_service" "isv_mongodbatlas_pvtlink_endpoint_service-2" {
  project_id          = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.project_id
  private_link_id     = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.private_link_id
  provider_name       = "GCP"
  endpoint_service_id = data.google_compute_network.vpc_compute_network2.name
  # endpoint_service_id = data.google_compute_network.vpc_compute_network.name
  gcp_project_id = var.gcp_project_id_2

  dynamic "endpoints" {
    for_each = mongodbatlas_privatelink_endpoint.isv_mongodbatlas_pvtlink_endpoint.service_attachment_names
    content {
      ip_address    = google_compute_address.compute_address_mongo-2[endpoints.key].address
      endpoint_name = google_compute_forwarding_rule.compute_forwarding_rule_mongo-2[endpoints.key].name
    }
  }
}