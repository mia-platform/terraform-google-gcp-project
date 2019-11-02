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

variable "name" {
  description = "The name for the project, will be suffixed by a random string"
  type        = string
}

variable "organization_id" {
  description = "Your GCP organization ID"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate to this project"
  type        = string
}

variable "folder_id" {
  description = "The ID of the folder in which you want to add this project"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Map of labels to add to the project"
  type        = map(string)
  default     = {}
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

variable "shared_vpc_project_id" {
  description = "The GCP ID of the shared VPC network host project"
  type        = string
  default     = ""
}

variable "shared_vpc_subnets_ids" {
  description = "List of subnets IDs"
  type        = list(string)
  default     = [""]
}
