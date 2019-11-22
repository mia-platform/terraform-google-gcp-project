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

output "project_id" {
  value = element(
    concat(
      [module.gcp_project_apis.project_id],
      [module.gcp_project.project_id]
    ),
  0)
  description = "The full project ID"
}

output "project_number" {
  value       = module.gcp_project.project_number
  description = "The project number"
}

output "service_account_id" {
  value       = module.gcp_project.service_account_id
  description = "The ID of the default service account"
}

output "service_account_email" {
  value       = module.gcp_project.service_account_email
  description = "The unique ID of the default service account"
}

output "labels" {
  value       = module.gcp_project.labels
  description = "Labels applied to the project"
}
