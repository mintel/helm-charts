# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.2.2] - 2023-02-06
### Added
- Add snapshot tests
### Fixed
- Upgrade to helm-unittest v0.3.0; fix problems it found

## [v0.2.1] - 2022-12-29
### Changed
- Refactor use of the `default` template function (sometimes use `coalesce`)
- Remove pointless `print` and `printf` function calls

### Fixed
- Make spacing inside `{{ }}` consistent

## [v0.2.0] - 2022-07-13
### Added
- Allow `Service` and `ExternalSecret` to be named explicitly using `nameOverride` option

### Changed
- Renamed `externalSecrets` to `extraSecrets` to align with existing helper in standard-app-stack chart

### Fixed
- Fixed `Service.selectorLabelsOverride` reference again (convert from yaml)

## [v0.1.1] - 2022-07-08
### Fixed
- Fixed `Service.selectorLabelsOverride` reference

## [v0.1.0] - 2022-07-04
### Added
- Added service template
- Added hybrid consul network policy template
- First full release of the Mintel basic-config helm chart
