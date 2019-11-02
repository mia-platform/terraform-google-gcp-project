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
  value       = google_project.project.project_id
  description = "The full project id"
}

output "project_number" {
  value       = google_project.project.number
  description = "The project number"
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "The email of the project service account"
}

output "service_account_id" {
  value       = google_service_account.service_account.name
  description = "The unique id of the default service account"
}