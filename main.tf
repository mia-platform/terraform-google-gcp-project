/*
  Copyright 2019 Mia srl

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

terraform {
  required_version = ">= 0.12"
  required_providers {
    google      = "~> 2.20"
    google-beta = "~> 2.20"
  }
}

locals {
  contains_container_api = contains(var.activate_apis, "container.googleapis.com")
}

module "gcp_project" {
  source = "./modules/gcp_project"

  name            = var.name
  organization_id = var.organization_id
  billing_account = var.billing_account
  folder_id       = var.folder_id
  labels          = var.labels
}

module "gcp_project_apis" {
  source = "./modules/gcp_project_apis"

  project_id    = module.gcp_project.project_id
  activate_apis = var.activate_apis
}

module "gcp_project_attach_shared_vpc" {
  source = "./modules/gcp_project_attach_shared_vpc"

  project_id                             = module.gcp_project_apis.project_id
  project_number                         = module.gcp_project.project_number
  shared_vpc_project_id                  = var.shared_vpc_project_id
  shared_vpc_subnets_ids                 = var.shared_vpc_subnets_ids
  enable_gke_user                        = local.contains_container_api
  project_controlling_service_account_id = "serviceAccount:${module.gcp_project.service_account_email}"
}
