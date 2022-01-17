# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v2.0.2] - 2022-01-17

### Fixed
- Remove priorityClassName from local manifests

## [v2.0.1] - 2022-01-17

### Removed
- Priority class definitions for local development (they are global definitions so block multiple deployments)

## [v2.0.0] - 2022-01-12

### Changed
- Drop support for Kubernetes < v1.21
- Leave Ingress class blank by default instead of setting it to `haproxy`

### Added
- Use Ingress PathType where possible, defaulting to `Prefix`

### Fixed
- Render Ingress service name and port correctly for `networking.k8s.io/v1`
- Use the `ingressClass` field instead of the `kubernetes.io/ingress.class` annotation where possible

## [v1.2.1] - 2022-01-11

## Added
- PriorityClass manifests for local development

### Fixed
- Changed Localstack serviceType to ClusterIP instead of NodePort

## [v1.2.0] - 2022-01-10

### Added
- Adding support for CronJobs

## [v1.1.0] - 2022-01-06

### Added
- Adding support for postgresql databases

## [v1.0.0] - 2021-12-13

### Added
- First full release of the Mintel standard-application-stack helm chart
