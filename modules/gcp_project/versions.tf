terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1, < 4.0.0"
    }
  }
}
