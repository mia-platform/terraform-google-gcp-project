# Terraform GCP Project

A Terraform module for creating a GCP project with opinionated options.

## Compatibility

This module is meant for use with Terraform 0.14.

## Requirements

### Software

- [Terraform][terraform] >= 0.14.0
- [terraform-provider-google][provider-google] plugin >= 4.5, < 5.0.0
- [terraform-provider-random][provider-random] plugin >= 3.1, < 4.0.0

### Permissions

In order to execute this module you must start the Google providers with a Service Account
with at least the following roles:

- `roles/resourcemanager.folderViewer` on the folder that you want to
  create the project in
- `roles/resourcemanager.organizationViewer` on the organization
- `roles/resourcemanager.projectCreator` on the organization
- `roles/billing.user` on the organization
- If you are using shared VPC:
  - `roles/billing.user` on the organization
  - `roles/compute.xpnAdmin` on the organization
  - `roles/compute.networkAdmin` on the organization
  - `roles/browser` on the Shared VPC host project
  - `roles/resourcemanager.projectIamAdmin` on the Shared VPC host project

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct,
and the process for submitting pull requests to us.

## Versioning

We use [SemVer][semver] for versioning. For the versions available,
see the [tags on this repository](https://github.com/mia-platform/terraform-google-project/tags).

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE.md](LICENSE.md)
file for details

[terraform]: https://www.terraform.io/downloads.html
[provider-google]: https://github.com/terraform-providers/terraform-provider-google
[provider-random]: https://github.com/terraform-providers/terraform-provider-random
[semver]: http://semver.org/
