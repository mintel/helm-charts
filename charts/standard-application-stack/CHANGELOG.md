# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v3.58.0] - 2023-01-25
### Added
- Ability to use host network for the main deployment

## [v3.57.0] - 2023-01-25
### Changed
- Bump version of mysqlclient docker image

## [v3.56.0] - 2023-01-24
### Added
- Added `ingress.alb.okta` values used for Okta ALB authentication
- Added `opensearch.awsEsProxy.ingress` values to allow placing opensearch behind an ingress

## [v3.55.2] - 2023-01-17
### Fixed
- Use `deepCopy` function when creating new dict from values

## [v3.55.1] - 2023-01-16
### Fixed
- Add check for service/pod monitor config dict settings before setting default for everything except main container

## [v3.55.0] - 2023-01-13
### Added
- Added shared helper for generating Pod Monitors and service monitors

### Changed
- Refactored pod monitors and service monitors to use new shared monitor helper

## [v3.54.1] - 2023-01-12
### Fixed
- Fixed bug with tf cloud secret list

## [v3.54.0] - 2023-01-09
### Added
- Added extra tests around Deployment `extraPorts`

### Fixed
- Validate usage of `extraPorts` when generating Deployment containerPort spec

## [v3.53.2] - 2022-12-29
### Changed
- Refactor use of the `default` template function (sometimes use `coalesce`)
- Remove pointless print functions from templates
- Make concatenated lists sorted and unique

### Fixed
- Make spacing inside `{{ }}` consistent

## [v3.53.1] - 2022-12-27
### Fixed
- Fix list of Terraform secrets to respect `secretNameOverride`

## [v3.53.0] - 2022-12-16
### Added
- Added template for `Job` resources, including config to support ArgoCD sync phases and waves.

## [v3.52.2] - 2022-12-15
### Changed
- Make `EXTRA_ALLOWED_HOSTS` env var unique and alphabetically sorted

### Fixed
- Add hosts from `extraIngresses` to `EXTRA_ALLOWED_HOSTS` env var

## [v3.52.1] - 2022-12-15
### Fixed
- Pass non-default terraform cloud secrets to stakater annotation correctly

## [v3.52.0] - 2022-12-09
### Added
- Added unit-tests for `ServiceMonitor` and `PodMonitor` resources

## [v3.51.2] - 2022-12-01
### Fixed
- Added missing `echo` to ingress.alb.preStopDelay

## [v3.51.1] - 2022-11-18
### Fixed
- Added `outputSecret: true` to defaults for AWS related values to allow TF Cloud chart add secrets by default

## [v3.51.0] - 2022-11-11
### Added
- Added ability to get correct secret names from terraform cloud helm chart

## [v3.50.0] - 2022-11-08
### Added
- Added `includeS3Secret` flag for cronjobs

## [v3.49.0] - 2022-10-04
### Added
- Added support for Network Load Balancers to route traffic to Services of type LoadBalancer

## [v3.48.0] - 2022-09-29
### Changed
- Remove `helm.sh/chart` annotation to avoid merge-request noise (keep on main Deployment/CronJob)

## [v3.47.0] - 2022-09-27
### Changed
- Disable `topologySpreadConstraints` when autoscaling from zero is enabled

## [v3.46.0] - 2022-09-26
### Added
- Added Keda `enableZeroReplicas` option
- Added Keda AWS trigger default handling for `awsRegion` and `identityOwner`
- Added Keda Prometheus trigger default handling for `serverAddress`

## [v3.45.0] - 2022-09-21
### Added
- Added support for multiple ingresses per app
- Added support for path based routing on ingresses
- Added support for setting X-Forwarded-For headers (haproxy ingress only)
- Added support for setting no-cache headers (haproxy ingress only)

## [v3.44.0] - 2022-09-20
### Added
- Added additional constraints around Keda values (`minReplicaCount`, `maxReplicaCount`, `pollingInterval` and `cooldownPeriod`)

## [v3.43.0] - 2022-09-20
### Changed
- Keda CPU / Memory scalers now uses `metricType`

### Fixed
- Fix handling of keda `targetMemoryAverageValue`

## [v3.42.0] - 2022-09-14
### Added
- Added extra support for autoscaling (conditionally drop pdbs and setting of replicas)
- Added extra tests around autoscaling/pdbs

### Fixed
- Fixed celery PodDisruptionBudget to only check for `celery.podDisruptionBudget.enabled`
- Fixed date on previous changelog entry

## [v3.41.0] - 2022-09-13
### Added
- Added support for https://keda.sh to handle autoscaling

### Removed
- Drop support for HorizontalPodAutoscaler (replaced by keda)

## [v3.40.0] - 2022-09-05
### Added
- Added support for volumes to cronjobs

## [v3.39.0] - 2022-08-12
### Added
- Added support for ALB Owner label being set on `Service
- Added extra `Service` unit-tests

## [v3.38.0] - 2022-08-12
### Changed
- Make AWS ALB (`alb-public-apps-default`) the default Ingress

## [v3.37.1] - 2022-08-02
### Fixed
- Stopped VPA template applying to local environment

## [v3.37.0] - 2022-08-01
### Removed
- Removed `k8s-notify` (not used anymore)

## [v3.36.0] - 2022-07-19
### Added
- Added horizontal-pod-autoscaler to standard app chart

## [v3.35.1] - 2022-07-18
### Fixed
- Add missing space to previous change causing chart to break

## [v3.35.0] - 2022-07-18
### Added
- Add ability to override celery startupProbe timeout value

## [v3.34.0] - 2022-07-15
### Added
- Add Event Bus environment variables

## [v3.33.1] - 2022-06-27
### Fixed
- Fixed clusterRoleBinding template

## [v3.33.0] - 2022-06-27
### Added
- Added option 'allowSingleReplica'
- Refactored logic around single replica deployments

## [v3.32.0] - 2022-06-24
### Added
- Added readiness and startup probes to aws-es-proxy deployments

## [v3.31.2] - 2022-06-21
### Changed
- Upping Celery liveness probe duration to 2s as it times out with 1s

## [v3.31.0] - 2022-06-15
### Added
- create VerticalPodAutoscaler from cronjobs

## [v3.31.0] - 2022-06-15
### Added
- allow creating a VerticalPodAutoscaler in recommendations-on

## [v3.30.0] - 2022-06-14
### Added
- ability for deployment to read SQS secret

## [v3.29.0] - 2022-06-10
### Note
- dummy release due to README mismatch

## [v3.28.0] - 2022-06-10
### Changed
- update subchart `chart.enabled` conditions to check env is local

## [v3.27.1] - 2022-06-09
### Changed
- allow celery and celery beat deployments consume s3 secret via envFrom. Deals with portal issue

## [v3.27.0] - 2022-06-08
### Added
- subchart `chart.enabled` conditions
- `Chart.lock` file

### Removed
- subchart `tar`s

## [v3.26.0] - 2022-06-08
### Changed
- updated defaultS3SecretName helper logic to handle mntl- prefix when terraform cloud helm is used

## [v3.25.0] - 2022-06-06
### Changed
- Update local dev stack charts to latest version and remove chart.lock file to combat [this issue](https://github.com/bitnami/charts/issues/10539)
- Add logic to use tf cloud generated IAM role for IRSA

## [v3.24.0] - 2022-05-25
### Changed
- ALB Ingress annotation now redirects to port 443 (from port 80)

## [v3.23.1] - 2022-05-24
### Fixed
- Fixed date on previous changelog entry

## [v3.23.0] - 2022-05-20
### Added
- Added toggle of AWS related external secret creation via `.Values.global.terraform.externalSecret`

## [v3.22.2] - 2022-05-20
### Fixed
- ALB Ingress should listen on port 80 as well (redirect rule to 443 is in place)

## [v3.22.1] - 2022-05-18
### Fixed
- Fixed oauthProxy regex for healthchecks (requires exact match)

## [v3.22.0] - 2022-05-17
### Removed
- Removed support for Ingress v1beta1

## [v3.21.2] - 2022-05-13
### Fixed
- Fix logic around ALB NetworkPolicy and increase test coverage

## [v3.21.1] - 2022-05-13
### Fixed
- Fixing changelog

## [v3.21.0] - 2022-05-13
### Fixed
- extraSecrets pathOverride was not referenced correctly

### Added
- Add nameOverride option to kubelock

## [v3.20.2] - 2022-05-13
### Fixed
- Fix indenting issue in standard deployment

## [v3.20.1] - 2022-05-12
### Fixed
- Disable network policies for local development

## [v3.20.0] - 2022-05-12
### Added
- Added DynamoDB support

## [v3.19.1] - 2022-05-12
### Fixed
- Set ALB healthcheck-port to use the oauthProxy port if enabled

## [v3.19.0] - 2022-05-12
### Changed
- Refactored logic around ingress extraHosts and oauthProxy.ingressHost to reduce duplication

## [v3.18.0] - 2022-05-12
### Changed
- Update oauthProxy to skip-auth for `/healthz`, `/readiness` and `/external-health-check` urls

## [v3.17.3] - 2022-05-11
### Fixed
- Fixed logic for setting port of alb network-policy if oauthProxy enabled

## [v3.17.2] - 2022-05-10
### Fixed
- Removed default value for oauthProxy.userIdClaim as the default is dependent on other values

## [v3.17.1] - 2022-05-10
### Fixed
- Fixed oauth2-proxy logic around using --email-domain to restrict access

## [v3.17.0] - 2022-05-10
### Added
- Added DynamoDB support

## [v3.16.0] - 2022-05-10
### Changed
- Change the default ALB healthcheck path from `/external-health-check` to `/readiness`

## [v3.15.1] - 2022-05-03
### Added
- Added `allow-aws-alb-internal-to-APP-NAME` NetworkPolicy for apps with an internal alb

## [v3.15.0] - 2022-05-03
### Added
- Added `ingress.alb.scheme` value to allow for choice of `internet-facing` or `internal` alb

## [v3.14.5] - 2022-05-03
### Fixed
- Fixed img.shields.io badge version (as a result of running `helm-docs`)

## [v3.14.4] - 2022-04-26
### Changed
- Change deprecated topologyKey from `failure-domain.beta.kubernetes.io/zone` to `topology.kubernetes.io/zone`

## [v3.14.3] - 2022-04-25
### Fixed
- Fixed service account irsa ARN annotation when service account name is overriden

## [v3.14.2] - 2022-04-25
### Fixed
- Fixed quoting of cronjob 'schedule' field so it will accept '/' in value, ie: '*/15 * * * *'

## [v3.14.1] - 2022-04-22
### Fixed
- Fix perpetual ArgoCD diff caused by default ExternalSecret refreshInterval

## [v3.14.0] - 2022-04-22
### Added
- Added support for pod `lifecycle` hooks
- Added AWS ALB helper for zero-downtime rollouts (using a `lifecycle.preStop`)
- Added support for pod `terminationGracePeriodSeconds`

## [v3.13.0] - 2022-04-19
### Added
- Added support for AWS ALB ingress (under `.Values.ingress.alb`)  and relevant configuration options
- Added NetworkPolicy `allow-aws-alb-to...` to allow ALB healthchecks to reach Pods
- Added new `helpers` directory (enable splitting of functions to aid maintainability)
- Added new ingress-tests for ALB

# Removed
- Removed `ingress.className` as this is determined from a helper function instead

## [v3.12.1] - 2022-04-07
### Fixed
- Remove ingress class from 'local' ingress so traefik works correctly

## [v3.12.0] - 2022-03-31
### Added
- Adding a default celery liveness and startup probes

## [v3.11.0] - 2022-03-30
### Added
- Adding support for hybrid-consul ports, networkPolicy and podMonitor

## [v3.10.0] - 2022-03-29

### Changed
- Replace Kubernetes External Secrets objects with External Secrets Operator objects

## [v3.9.1] - 2022-03-25

### Added
- Added support for setting Consul (hybrid-cloud) annotations

## [v3.8.2] - 2022-03-02

### Changed
- Updated monitoring cluster URL for k8s-notify from GKE to EKS

## [v3.8.1] - 2022-03-01

### Fixed
- Don't render the `tls:` key of the Ingress when `ingress.specificTlsHostsYaml` and `global.ingressTLSSecrets` are both empty

## [v3.8.0] - 2022-03-01

### Added
- Added support to set `env`, `scope` and `userIdClaim`  values for the oauth proxy sidecar

## [v3.7.0] - 2022-02-25

### Added
- Added `gitSyncSidecar` helper for syncing a git repository into a local directory

## [v3.6.1] - 2022-02-22

### Fixed
- [CPT-679](https://mintel.atlassian.net/browse/CPT-679): Include logic to change defaults based on environment.

## [v3.6.0] - 2022-02-21

### Changed
- [CPT-679](https://mintel.atlassian.net/browse/CPT-679): Changed `topologySpreadConstraints.node.enabled` default to `true`.

### Fixed
- Changelog formatting

## [v3.5.1] - 2022-02-03

### Fixed
- Fixed handling of singleline/multiline configmap data strings

## [v3.5.0] - 2022-02-03

### Added
- Added `includeBasePodSecurityContext` flag for cronjobs

## [v3.4.0] - 2022-02-03

### Added
- Added `cronjobsOnly` flag to only show cronjobs and relevant resources (i.e. skip deployment / service etc)

## [v3.3.0] - 2022-02-01

### Added
- Added annotation to skip opa check for security context to deployment-aws-es-proxy.yaml,
  deployment-celery-exporter.yaml, deployment-mysqldexporter.yaml and deployment-postgresqlexporter.yaml

## [v3.2.2] - 2022-02-01

### Fixed
- Corrected enable to enabled under kubelock in values.yaml

## [v3.2.1] - 2022-01-31

### Added
- Added Unit tests

## [v3.2.0] - 2022-01-28

### Added
- Added ability to explicitly allow readiness/liveness URLs through ingress

### Fixed
- Removed incorrect `apiGroups` element from `subjects` in role-bindings

## [v3.1.0] - 2022-01-27

### Changed
- Variable under ingress changed to extraAnnotations

### Fixed
- Allow extra annotations from values to be populated in ingress manifest

## [v3.0.1] - 2022-01-27

### Changed
- Added feature toggles for including env and secrets into cronjobs

### Fixed
- Remove extraSecrets from stakater when not included in deployment

## [v3.0.0] - 2022-01-27

### Changed
- Changed how 'args' are handled, from a dict to a list, so that their order is determinisitic

## [v2.4.1] - 2022-01-26

### Fixed
- Fixed sequencing of values overrides for additionalMonitors (pod and service)

## [v2.4.0] - 2022-01-26

### Changed
- Disable database exporters by default since we capture RDS metrics using cloudwatch

### Fixed
- A few typos in the `values.yaml` file (comments only)

## [v2.3.5] - 2022-01-26

### Fixed
- Pass through postgresql port from generated instance information (rather than assuming `5432`)

## [v2.3.4] - 2022-01-25

### Fixed
- Fixed creating configmaps to avoid unwanted newlines

## [v2.3.3] - 2022-01-25

### Fixed
- Fixed port names for additional service monitors
- Fixed basicAuth for service monitors and pod monitors
- Fixed adding of oauth proxy secret to secretList

## [v2.3.2] - 2022-01-25

### Fixed
- Fixed auth-proxy secret not being added to stakater secret reload list

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

### Added
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
