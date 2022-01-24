# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v2.3.1] - 2022-01-24

### Added
- Added ability to exclude specific extraSecrets from main deployment

## [v2.3.0] - 2022-01-24

### Added
- Added ability to specify ServiceAccount Roles and ClusterRoles

### Fixed
- Fixed ability to override serviceAccountName

## [v2.2.6] - 2022-01-24

### Changed
- Enable skipping auth for specific URLs through oauth-proxy

## [v2.2.5] - 2022-01-24

### Fixed
- Expose auth-proxy-metrics port through service

## [v2.2.4] - 2022-01-24

### Fixed
- Expose oauth-proxy port through service

## [v2.2.3] - 2022-01-20

### Changed
- Changed oauth proxy OIDC issuer Url from an env var to a values argument with sane default

## [v2.2.2] - 2022-01-20

### Fixed
- Fixed arguments for oauth-proxy container

## [v2.2.1] - 2022-01-20

### Fixed
- `PodMonitor` port does not have a `main-` prefix

## [v2.2.0] - 2022-01-20

### Changed
- Allow setting port to null to skip adding containerPorts to deployment

## [v2.1.4] - 2022-01-19

### Added
- Added kubelock.enabled value (default: false)

### Changed
- Only set KUBELOCK env var's if kubelock enabled
- Only create role/rolebinding if kubelock enabled
- Set strategy type to Recreate for single replica deployments
- Create pod-monitors instead of service-monitors if service not enabled

### Fixed
- Only populate `EXTRA_ALLOWED_HOSTS` if ingress enabled

### Removed
- Removed topologySpreadConstraints on single replica deployments

## [v2.1.3] - 2022-01-19

### Fixed
- Fixed adding of extraSecrets to envFrom of deployment

## [v2.1.2] - 2022-01-19

### Fixed
- Fixed setting of periodSeconds on liveness and readiness probes

## [v2.1.1] - 2022-01-18

### Fixed
- Fixing typo on networkPolicy.additionalAllowFroms in values.yml

## [v2.1.0] - 2022-01-18

### Added
- Added back in support for Ingress v1beta1 via .Values.ingress.apiVersion
- Added support for PersistentVolumeClaim's
- Added support for additional custom secrets
- Fully implement oauth-proxy throughout chart
- Added support for StatefulSet's (.Values.statefulset)
- Added argument to explicitly define single replica apps (.Values.singleReplicaOnly)
- Added support for network policies allowing access from other apps
- Added support for basic auth on service monitor endpoints
- Added support for defining additional service monitors
- Added support for extraPorts on a deployment

### Changed
- Enable liveness/readiness ports to be configurable

### Fixed
- Generate fullname from more reliable variable .Values.global.name
- Fixed generation of configmap list for stakater reloader
- Fixed generation of configmap manifests
- Fixed typo in argo sync-options annotations

### Removed
- Removed redundant redis-client label

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
