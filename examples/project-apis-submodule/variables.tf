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

variable "project_id" {
  description = "The GCP ID of the project that will be attached to the shared VPC network"
  type        = string
}

variable "credentials_path" {
  description = "Path to a service account credentials file with the correct IAM roles to run the module. If this file is absent the Google Provider will fall back to the gcloud Application Default Credentials of your machine."
  default     = ""
}
