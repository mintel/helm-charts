# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
