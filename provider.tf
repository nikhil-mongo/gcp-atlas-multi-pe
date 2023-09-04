provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}
provider "google" {
  credentials = file("")
  project     = "terraform-gcp-atlas"
  region      = "europe-west3"
  alias       = "acc1"
}
provider "google" {
  credentials = file("")
  project     = "My Project 25750"
  region      = "europe-west3"
  alias       = "acc2"
}