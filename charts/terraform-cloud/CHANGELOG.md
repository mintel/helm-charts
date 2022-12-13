# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.30.0] - 2022-12-13
### Changed
- Bump version of S3 Terraform module to allow option to create cloudfront distribution

## [v0.29.0] - 2022-12-09
### Added
- Now supports creating an ExternalSecret for the Secrets Manager secret the app-iam module can create (see [here](https://gitlab.com/mintel/satoshi/infrastructure/terraform-cloud/terraform-aws-modules/terraform-aws-app-iam/-/merge_requests/15))

## [v0.28.1] - 2022-12-08
### Changed
- Bump version of OpenSearch Terraform module to fix AWS provider version constraints

## [v0.28.0] - 2022-11-08
### Changed
- Bump version of S3 Terraform module to allow sftp access

## [v0.27.0] - 2022-10-25
### Changed
- Bump versions of mariadb, postgresql, redis and staticWebsite Terraform modules

## [v0.26.0] - 2022-10-19
### Added
- Added option to configure ArgoCD `sync-wave` per resource-type

## [v0.25.3] - 2022-10-14
### Changed
- Bump version of sshKeyPairSecret module

## [v0.25.2] - 2022-10-13
### Fixed
- Actually enabling eks_namespace var to be passed to sshKeyPairSecret module
- Bump version of sshKeyPairSecret module

## [v0.25.1] - 2022-10-13
### Changed
- Bumped ssh-keypair-secret module version

## [v0.25.0] - 2022-10-13
### Added
- Added sshKeyPairSecret module

## [v0.24.1] - 2022-10-12
### Fixed
- Fixed readme

## [v0.24.0] - 2022-09-15
### Added
- Support for activeMQ, auroraMySql and auroraPostgresql via AWS and Terraform module

## [v0.23.1] - 2022-09-09
### Fixed
- Update RDS Terraform module version to fix AWS provider version constraint problem

## [v0.23.0] - 2022-09-09
### Fixed
- Bump S3 module to v1.1.2

## [v0.22.0] - 2022-08-19
### Changed
- Bump IAM role module to v2.0.0

## [v0.21.0] - 2022-08-16
### Changed
- Bump default Opensearch module version to add scheduled snapshot functionality

## [v0.20.0] - 2022-07-29
### Changed
- Bump default S3 module version to setup access logging by default

### Fixed
- Bump default memcached module version for bugfix in picking up private app subnets

## [v0.19.1] - 2022-07-27
### Fixed
- Give precedence to defaultVars over environment defaults when setting module variables

## [v0.19.0] - 2022-07-26
### Added
- Ability to use data to adjust secret key values in external secret

## [v0.18.7] - 2022-07-26
### Changed
- Point irsa module version default to 1.0.1 after bugfix for destroy

## [v0.18.6] - 2022-07-25
### Changed
- Correct multi_az prod default for rds to true

## [v0.18.5] - 2022-07-21
### Changed
- Bump RDS version to v1.0.1

## [v0.18.4] - 2022-07-20
### Changed
- Bump all terraform cloud module versions to v1.0.0

## [v0.18.3] - 2022-07-14
### Fixed
- Bump rds and opensearch modules to allow using a var for snapshot bucket versioning

## [v0.18.2] - 2022-07-13
### Fixed
- Consolidate default workspace tags to avoid hitting limits

## [v0.18.1] - 2022-07-12
### Changed
- Bump default s3, rds and opensearch module versions to avoid S3 mfa_delete bug

## [v0.18.0] - 2022-07-11
### Added
- Annotations to be used for terraform cloud operator extension with helpers and overrides

## [v0.17.0] - 2022-07-04
### Added
- Initial support for step-functions-eks module
- Ability to make external secret creation optional
- Add direct app.kubernetes.io/name label for workspaces to avoid overriding by wrappers

## [v0.16.1] - 2022-07-01
### Added
- Bump s3, mariadb, postgesql and opensearch default versions for versioning bugfix

## [v0.16.0] - 2022-06-27
### Added
- Add shortened name label to deal with char limit

### Fixed
- Bump default s3, rds and opensearch versions to deliver new S3 versioning fix

## [v0.15.1] - 2022-06-27
### Fixed
- Bumped version of opensearch module to fixed version

## [v0.15.0] - 2022-06-27
### Added
- Bumped version of opensearch module

## [v0.14.1] - 2022-06-20
### Added
- Fix precedence of dicts when considering env defaults

## [v0.14.0] - 2022-06-20
### Added
- Bump default app-iam module

## [v0.13.0] - 2022-06-17
### Added
- Add ability to override workspace name

## [v0.12.0] - 2022-06-15
### Added
- Setting environment based defaults for resources via helpers
- refactor helpers to have `mintel_common.terraform_cloud` prefix rather than just `mintel_common.`
- bump sqs module version


## [v0.11.0] - 2022-06-13
### Fixed
- Apply kebabcase to instance name when generating workspace name

## [v0.10.1] - 2022-06-13
### Fixed
- Bump default app-iam module version to fix issue with consume_sqs_queues var

## [v0.10.0] - 2022-06-13
### Changed
- Add ability to create irsa workspace explicitly

## [v0.9.0] - 2022-06-09
### Changed
- Bump default terraform module versions for app-iam, redis and opensearch

## [v0.8.0] - 2022-06-08
### Changed
- Bump default app-iam module version

## [v0.7.3] - 2022-06-07
### Fixed
- Use helper for instance name to generate runTriggers

## [v0.7.2] - 2022-06-07
### Fixed
- Syntax error with name helper

## [v0.7.1] - 2022-06-07
### Fixed
- Use helper to generate instance name across secret and workspace
- Update irsa required helper to use string

## [v0.7.0] - 2022-06-07
### Added
- Auto add mntl- prefix to S3 bucket name if not added explicitly
- Shorten IRSA workspace names
- Remove hash trigger for IRSA as not needed with run triggers
- Add sync wave for Output secret

## [v0.6.1] - 2022-06-07
### Fixed
- Issue with IRSA workspace adding in null var

## [v0.6.0] - 2022-06-06
### Added
- Refactor workspace logic to use more helpers
- Add option to tf cloud config for it to control IRSA and allow blue-green deploy with IAM role having app-iam prefix


## [v0.5.0] - 2022-06-01
### Added
- Add ability to create IRSA using app-iam module when provisioning required resources
- Add ability to override terraform version at the module level

## [v0.4.1] - 2022-05-27
### Fixed
- Fixed issue where could not override certain vars

## [v0.4.0] - 2022-05-26
### Changed
- Bumped default referenced modules for redis and S3

## [v0.3.0] - 2022-05-25
### Added
- Added app.mintel.com/altManifestFileSuffix to workspace spec to be used in manifest generation

### Changed
- Changed workspace-output-secret secret store to aws-secrets-manager-local

## [v0.2.0] - 2022-05-24
### Changed
- Changed workspace-output-secret name to match what is currently used in standard app stack i.e app_name-resource_type

## [v0.1.1] - 2022-05-23
### Changed
- Set agentPoolId as a value to be pulled from cluster env jsonnet

## [v0.1.0] - 2022-05-18

### Added
- First full release of the Terraform-cloud helm chart
