# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
