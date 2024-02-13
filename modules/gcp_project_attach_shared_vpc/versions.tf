terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.72, < 6.0.0"
    }
  }
}
