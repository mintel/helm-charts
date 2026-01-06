# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.19.0] - 2025-12-19
### Changed
- Updated helm and helm-docs versions so the unittest plugin would work again.
- Updated default Lambda module version to 8.0.1
### Fixed
- Remove `owner` variable from Lambda workspaces (this is no longer used by the module and produces an error whenever
  it's used).

## [v1.18.1] - 2025-11-25
### Changed
- Update `glue` module to latest version (to include a bugfix)

## [v1.18.0] - 2025-11-25
### Added
- Added support for `glue` module

## [v1.17.0] - 2025-10-13
### Added
- Added support for `backstage.component` being set on `Workspace` resources

## [v1.16.1] - 2025-05-13
### Fixed
- Added `kinesis-firehose` to supported resources list for terraform cloud helm chart

## [v1.16.0] - 2025-04-14
### Added
- Added support for `kinesis-firehose` workspaces

## [v1.15.1] - 2025-03-12
### Added
- Add environment variable to set AWS default tag `TerraformCloudWorkspace`

## [v1.15.0] - 2024-09-17
### Added
- INFRA-36982: Support for S3 multi-region access point and replication rules modules.

## [v1.14.0] - 2024-09-04
### Changed
- Bump `opensearch` module to `1.6.0`

## [v1.13.0] - 2024-08-02
### Changed
- Bump `redis` module to `1.3.0`
- Bump `memcached` module to `1.0.3`

## [v1.12.0] - 2024-07-29
### Added
- Added dynamodb deletion_protection_enabled defaults

### Changed
- Bump `dynamodb` module version to `1.3.0`

## [v1.11.0] - 2024-07-03
### Changed
- Bump `redis` module version to `1.2.1`

## [v1.10.0] - 2024-07-03
### Changed
- Bump `redis` module version to `1.2.0`

## [v1.9.0] - 2024-06-17
### Removed
- Remove v1 operator support (only v2 is supported now)

## [v1.8.2] - 2024-06-17
### Fixed
- Fix handling of `workspaceNameOverride` when `operatorVersion: "migrate"` used

## [v1.8.1] - 2024-06-10
### Fixed
- Fix handling of `workspaceNameOverride` - was being unset prior to rendering of Module

## [v1.8.0] - 2024-06-07
### Added
- Update v2 workspace to configure `spec.teamAccesss`

## [v1.7.0] - 2024-06-07
### Changed
- Update v2 workspace to configure `spec.tags`

### Removed
- Remove v2 workspace custom-extension annotations (will be handled by `spec.tags` and `spec.teamAccess`)

## [v1.6.0] - 2024-06-06
### Added
- Added IRSA tests for workspace-v2 (copied and adjust v1 version)

### Fixed
- Fix call to `irsaRunTriggers` for v2 workspace (was rendering v1 version)

## [v1.5.0] - 2024-05-31
### Changed
- Update logic around default destroy mode. Same function is now used to handle the custom `app.mintel.com/terraform-allow-destroy` and  the v2 `spec.allowDestroyPlan`

## [v1.4.0] - 2024-05-30
### Added
- Add global default for setting Workspace `workspaceAllowDestroy`
- Add global default for setting Workspace `applyMethod`

## [v1.3.0] - 2024-05-29
### Added
- Add support for `app.terraform.io/v1alpha2` API version

## [v1.2.0] - 2024-05-29
### Changed
- Update v2 configuration to use same defaults for allowing workspace-destroy in prod/logs account. Also allow overrides at resource-config layer.

## [v1.1.0] - 2024-05-22
### Added
- Added support for terraform-cloud-operator v2. v1 is still the default and would result in a noop for appliations consuming this chart.

## [v1.0.0] - 2024-04-25
### Changed
- Bumped all module versions to the current latest

## [v0.51.0] - 2024-01-13
### Changed
- Bumped s3 module version to `2.0.5`

## [v0.50.0] - 2023-11-13
### Changed
- Bumped rds related module versions to `1.3.0`
- Bumped default terraform version to `1.2.9`

## [v0.49.0] - 2023-10-24
### Added
- Added support for `datasync` workspaces

## [v0.48.0] - 2023-10-17
### Added
- SQS support for subscribing to SNS topics in another region.

## [v0.47.0] - 2023-09-25
### Added
- Extra Job service accounts now get added to the list of accounts that are granted access to AWS resources if required.

## [v0.46.1] - 2023-09-04
### Added
- Bump IRSA module version. Fixes an issue with duplicate SIDs being created for S3 buckets with mixed sources.

## [v0.46.0] - 2023-08-30
### Added
- Added tfcloud-auto-approver Lambda notifications to IRSA workspaces

## [v0.45.0] - 2023-08-22
### Changed
- Update `component` reporting label to default to application name (`global.name`)

## [v0.44.0] - 2023-08-21
### Added
- Added support for new reporting labels `application` and `component`

## [v0.43.3] - 2023-08-04
### Changed
- Upgrade external-secrets api version from v1alpha1 to v1beta1.

## [v0.43.2] - 2023-07-28
### Changed
- Bump ssh key module (fixes key generation script)

## [v0.43.1] - 2023-06-28
### Fixed
- Bump rds module version. Fixes an issue when using gp3 as the storage type (https://github.com/hashicorp/terraform-provider-aws/issues/28271)

## [v0.43.0] - 2023-06-28
### Removed
- Remove `helm.sh/chart` annotation from all remaining manifests.

## [v0.42.0] - 2023-06-20
## Added
- Support for creating Lambda functions

## [v0.41.1] - 2023-05-25
### Changed
- Bump api-gateway module to 0.3.2

## [v0.41.0] - 2023-05-25
### Added
- Added `api-gateway-http` module
### Changed
- Alphabetized resources in values.yaml

## [v0.40.1] - 2023-05-12
### Changed
- No-op release to trigger chart releaser action which didn't run for v0.40.0 release

## [v0.40.0] - 2023-05-10
### Added
- Add `cms-backup` module

## [v0.39.1] - 2023-04-27
### Fixed
- Update `s3` module to `v1.4.1` for acl fix with additional dependency

## [v0.39.0] - 2023-04-24
### Changed
- Update `s3` module to `v1.4.0` for acl fix

## [v0.38.0] - 2023-04-19
### Changed
- Update `sqs` module to `v1.1.0`

## [v0.37.0] - 2023-04-17
### Added
- Add ability set MintelEventBus tags for SQS and SNS

## [v0.36.0] - 2023-04-14
### Added
- Add ability to set custom tags for aws resources

## [v0.35.0] - 2023-02-09
### Changed
- Update `opensearch` module to `v1.2.1`

## [v0.34.1] - 2023-02-06
### Added
- Add snapshot tests
### Fixed
- Upgrade to helm-unittest v0.3.0; fix problems it found

## [v0.34.0] - 2023-02-07
### Changed
- Bump s3 module version to get new fixes

## [v0.33.0] - 2023-02-02
### Changed
- Bump app-iam module version to include refactor of resource filtering

## [v0.32.0] - 2023-02-01
### Changed
- Add extraIAM resource type to allow additional IAM users and roles
- Bump app-iam module version to include bugfix

## [v0.31.0] - 2023-01-27
### Changed
- Update `opensearch` module to `v1.2.0`

## [v0.30.1] - 2022-12-29
### Changed
- Refactor use of the `default` template function (sometimes use `coalesce`)
- Remove pointless `print` and `printf` function calls
- Make concatenated lists sorted and unique

### Fixed
- Make spacing inside `{{ }}` consistent

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
