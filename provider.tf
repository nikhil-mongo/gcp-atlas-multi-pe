provider "mongodbatlas" {
  public_key  = "phfzvxuf"
  private_key = "218328da-c430-49ee-8461-24b741c31b7a"
}
provider "google" {
  credentials = file("terraform-gcp-atlas-6789e2772613.json")
  project     = "terraform-gcp-atlas"
  region      = "europe-west3"
  alias       = "acc1"
}
provider "google" {
  credentials = file("hardy-device-394612-e7642b71bc62.json")
  project     = "My Project 25750"
  region      = "europe-west3"
  alias       = "acc2"
}
variable "atlas_region" {
  description = "Atlas region to use for PSC"
}
variable "gcp_region" {
  description = "GCP region to deploy PSC"
}