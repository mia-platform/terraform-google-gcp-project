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

locals {
  uniqued_apis = toset(var.activate_apis)
  enabled_apis = [for service in google_project_service.gcp_project_apis : service.service]
  project_ids  = [for service in google_project_service.gcp_project_apis : service.project]
}

resource "google_project_service" "gcp_project_apis" {
  for_each = local.uniqued_apis

  service = each.value
  project = var.project_id

  disable_dependent_services = true
  disable_on_destroy         = true
}
