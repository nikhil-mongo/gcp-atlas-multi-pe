provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}
provider "google" {
  credentials = file("terraform-gcp-atlas-6789e2772613.json")
  project     = var.gcp_project_name_1
  region      = var.gcp_region
  alias       = "acc1"
}
provider "google" {
  credentials = file("hardy-device-394612-e7642b71bc62.json")
  project     = var.gcp_project_name_2
  region      = var.gcp_region
  alias       = "acc2"
}