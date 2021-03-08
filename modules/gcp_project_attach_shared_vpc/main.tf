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
    google      = ">= 2.19.0"
    google-beta = ">= 2.19.0"
  }
}

locals {
  enable_module = var.shared_vpc_project_id != ""
  google_api_service_account = format(
    "serviceAccount:%s@cloudservices.gserviceaccount.com",
    var.project_number,
  )
  gke_service_account = var.enable_gke_user ? format(
    "serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com",
    var.project_number,
  ) : ""
  enable_gke_sa_role = local.enable_module && var.enable_gke_user
  vpc_users = compact([
    local.google_api_service_account,
    local.gke_service_account,
    var.project_controlling_service_account_id
  ])
  total_vpc_users         = length(local.vpc_users)
  uniqued_subnet_ids      = compact(var.shared_vpc_subnets_ids)
  total_subnet_ids        = length(local.uniqued_subnet_ids)
  enable_subnetwork_roles = local.total_subnet_ids > 0
}

resource "google_compute_shared_vpc_service_project" "shared_vpc_attachment" {
  count = local.enable_module ? 1 : 0

  host_project    = var.shared_vpc_project_id
  service_project = var.project_id
}

resource "google_project_iam_member" "service_accounts_vpc_membership" {
  count = local.enable_module && local.total_subnet_ids == 0 ? local.total_vpc_users : 0

  project = var.shared_vpc_project_id
  role    = "roles/compute.networkUser"
  member  = element(local.vpc_users, count.index)

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}

resource "google_compute_subnetwork_iam_member" "google_api_service_account_role_to_vpc_subnets" {
  provider = google-beta
  count    = local.enable_module && local.enable_subnetwork_roles ? local.total_subnet_ids : 0

  subnetwork = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(
      split("/", local.uniqued_subnet_ids[count.index]),
      "subnetworks",
    ) + 1,
  )
  role = "roles/compute.networkUser"
  region = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(split("/", local.uniqued_subnet_ids[count.index]), "regions") + 1,
  )
  project = var.shared_vpc_project_id
  member  = local.google_api_service_account

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}

resource "google_compute_subnetwork_iam_member" "controlling_service_account_role_to_vpc_subnets" {
  provider = google-beta
  count    = local.enable_module && local.enable_subnetwork_roles ? local.total_subnet_ids : 0

  subnetwork = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(
      split("/", local.uniqued_subnet_ids[count.index]),
      "subnetworks",
    ) + 1,
  )
  role = "roles/compute.networkUser"
  region = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(split("/", local.uniqued_subnet_ids[count.index]), "regions") + 1,
  )
  project = var.shared_vpc_project_id
  member  = var.project_controlling_service_account_id

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}

resource "google_compute_subnetwork_iam_member" "gke_service_account_role_to_vpc_subnets" {
  provider = google-beta
  count    = local.enable_gke_sa_role && local.enable_subnetwork_roles ? local.total_subnet_ids : 0

  subnetwork = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(
      split("/", local.uniqued_subnet_ids[count.index]),
      "subnetworks",
    ) + 1,
  )
  role = "roles/compute.networkUser"
  region = element(
    split("/", local.uniqued_subnet_ids[count.index]),
    index(split("/", local.uniqued_subnet_ids[count.index]), "regions") + 1,
  )
  project = var.shared_vpc_project_id
  member  = local.gke_service_account

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}

resource "google_project_iam_member" "gke_host_agent_to_shared_vpc_project" {
  count   = local.enable_gke_sa_role ? 1 : 0
  project = var.shared_vpc_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = local.gke_service_account

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}

# This role is required for allowing the automatic creation of load balancing resources by the
# Ingress and LoadBalancer Service Kubernetes resources
resource "google_project_iam_member" "gke_security_admin_to_shared_vpc_project" {
  count   = local.enable_gke_sa_role ? 1 : 0
  project = var.shared_vpc_project_id
  role    = "roles/compute.securityAdmin"
  member  = local.gke_service_account

  # HACK! Force the dependencies on this value because modules can not set their depends_on
  depends_on = [
    var.project_id
  ]
}
