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

provider "google" {
  credentials = file(var.credentials_path)
}

data "google_project" "gcp_project" {
  project_id = var.project_id
}

data "google_compute_network" "vpc-shared-network" {
  name    = var.shared_vpc
  project = var.shared_vpc_project
}

module "attach_shared_vpc" {
  source                                 = "../../modules/gcp_project_attach_shared_vpc"
  project_id                             = data.google_project.gcp_project.project_id
  project_number                         = data.google_project.gcp_project.number
  project_controlling_service_account_id = var.project_service_account
  enable_gke_user                        = false

  shared_vpc_project_id  = data.google_compute_network.vpc-shared-network.project
  shared_vpc_subnets_ids = data.google_compute_network.vpc-shared-network.subnetworks_self_links
}
