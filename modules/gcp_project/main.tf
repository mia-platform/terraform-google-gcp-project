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

resource "random_id" "random_project_suffix" {
  byte_length = 2
  keepers = {
    name = var.name
  }
}

locals {
  project_id = "${random_id.random_project_suffix.keepers.name}-${random_id.random_project_suffix.hex}"
  org_id     = var.folder_id == "" ? var.organization_id : ""
  folder_id  = var.folder_id != "" ? var.folder_id : ""
}

resource "google_project" "project" {
  name                = random_id.random_project_suffix.keepers.name
  project_id          = local.project_id
  org_id              = local.org_id
  folder_id           = local.folder_id
  billing_account     = var.billing_account
  skip_delete         = false
  labels              = var.labels
  auto_create_network = false
}

resource "google_service_account" "service_account" {
  account_id   = "service-account"
  display_name = "${var.name} Service Account"
  description  = "The project service account created by Terraform"
  project      = google_project.project.project_id
}
