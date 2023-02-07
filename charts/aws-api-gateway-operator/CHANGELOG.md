# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.1.2] - 2023-02-06
### Added
- Add snapshot tests
### Changed
- Upgrade standard-application-stack subchart version
### Fixed
- Upgrade to helm-unittest v0.3.0; fix problems it found

## [v0.1.1] - 2022-12-29
### Changed
- Refactor use of the `default` template function (sometimes use `coalesce`)
- Remove pointless `print` and `printf` function calls

## [v0.1.0] - 2022-06-07
### Added
- Added initial chart implementation
