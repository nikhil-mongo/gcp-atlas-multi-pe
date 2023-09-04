
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.69.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.69.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.0"
    }
  }
}
