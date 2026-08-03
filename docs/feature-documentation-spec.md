# Feature-oriented documentation spec

This document is a **feature reference for configuring Helm values** in the `standard-application-stack` and `terraform-cloud` charts. It is intended for:

- **Humans** configuring or reviewing application deployments
- **LLM agents** (e.g. a Jsonnet values-authoring skill) that need to know which values to set, valid combinations, and cross-feature constraints

For each feature the doc describes:

1. **Variables** — value paths involved (see companion files for defaults and types)
2. **Configure** — common intents and what to set (where piloted or added)
3. **Constraints and interactions** — gates, conflicts, and dependencies between values
4. **Chart behavior** — short summary of affected manifests (not a template reimplementation guide)

**How to use:** When configuring a feature, set the listed value paths in your Jsonnet/Tanka values object. Cross-check defaults and types in the chart `values.yaml` files. Use the constraints section to avoid combinations that silently no-op or conflict.

## Related references

Always cross-reference these companion sources:

| Source | Purpose |
|--------|---------|
| [charts/standard-application-stack/values.yaml](../charts/standard-application-stack/values.yaml) | Defaults, types, and inline descriptions for app workload values |
| [charts/terraform-cloud/values.yaml](../charts/terraform-cloud/values.yaml) | Defaults, types, and inline descriptions for Terraform Cloud resource values |
| [.cursor/plans/values_and_effects_report_9aa4cfcc.plan.md](../.cursor/plans/values_and_effects_report_9aa4cfcc.plan.md) | Per-key effects tables complementing this feature-oriented view |

Both charts consume the same `global` values object when deployed via Tanka. When enabling a backend with `global.terraform.externalSecrets: true`, set values consistently on **both** charts (terraform-cloud creates secrets; standard-application-stack injects secret refs).

---

## 1. Workload basics

### 1.1 Changing the number of replicas

<!-- feature: workload.replicas -->

**Variables:** `replicas`, `singleReplicaOnly`, `allowSingleReplica`, `autoscaling.enabled`, `autoscaling.minReplicaCount`, `autoscaling.maxReplicaCount`

**Configure:**

- **Fixed replica count:** Set `replicas` (default `2`). Keep `autoscaling.enabled: false`.
- **Scale with KEDA:** Set `autoscaling.enabled: true` and configure `autoscaling.minReplicaCount` / `autoscaling.maxReplicaCount`. Do not rely on `replicas` for scaling.
- **Exactly one replica (no rolling updates):** Set `singleReplicaOnly: true` (ignores `replicas`).
- **One replica with rolling updates allowed:** Set `replicas: 1` and `allowSingleReplica: true`.

**Constraints and interactions:**

- When `autoscaling.enabled` is true and `global.clusterEnv` is not `"local"`, the workload `replicas` value is ignored; KEDA controls scale via a ScaledObject (see section 3.1).
- When `singleReplicaOnly` is true, `strategy.type` is forced to `Recreate` (see section 1.8).
- When **either** `singleReplicaOnly` or `allowSingleReplica` is true, the workload gets OPA annotation `app.mintel.com/opa-allow-single-replica: "true"`.
- Main PDB is created only when `podDisruptionBudget.enabled` is true **and** replica count is > 1 (uses `autoscaling.minReplicaCount` when autoscaling is enabled, else `replicas`).
- Topology spread is rendered only when `global.clusterEnv` != `"local"`, `replicas` > 1, and not (`autoscaling.enabled` and `autoscaling.enableZeroReplicas`). Note: topology spread uses `Values.replicas`, not `minReplicaCount`.

**Chart behavior:**

- Deployment/StatefulSet replica count, ScaledObject (when autoscaling), PDB, topology spread constraints
- Sources: `templates/deployment.yaml`, `templates/keda-scaled-object.yaml`, `templates/pdbs.yaml`

---

### 1.2 Choosing Deployment vs StatefulSet

<!-- feature: workload.deployment-statefulset -->

**Variables:** `statefulset`, `persistentVolumes`

**Logic (implementation detail):**

- **When `statefulset` is true:**
  - Kind is StatefulSet; apiVersion from `common.capabilities.statefulset.apiVersion`.
  - `spec.volumeClaimTemplates` is rendered from each entry in `persistentVolumes` (name: `fullname-<volume.name>`, accessModes, storageClassName if set, resources.requests.storage).
  - `spec.updateStrategy` is set to `type: RollingUpdate`; `spec.serviceName` is set to fullname.
  - **`minReadySeconds` is not rendered** for StatefulSet (the template wraps minReadySeconds in `{{- if (eq .Values.statefulset false) }}`).
  - Standalone PVCs in `pvcs.yaml` are **not** created (pvcs.yaml only iterates when `statefulset` is false).
  - KEDA ScaledObject’s `scaleTargetRef.kind` is set to `StatefulSet` when statefulset is true.
- **When `statefulset` is false:**
  - Kind is Deployment.
  - `minReadySeconds` is rendered from `Values.minReadySeconds` if set.
  - Each entry in `persistentVolumes` produces a separate PVC in `pvcs.yaml` and can be mounted via volumeMounts (no volumeClaimTemplates on the Deployment).

---

### 1.3 Setting the container image and pull policy

**Variables:** `image.registry`, `image.repository`, `image.tag`, `image.pullPolicy`, `imagePullSecrets`

**Logic (implementation detail):**

- Full image is built from registry/repository:tag (helper `mintel_common.image`); per-workload overrides (e.g. celery, cronjob job image) can replace entirely.
- `imagePullPolicy` comes from helper (default IfNotPresent).
- `imagePullSecrets` is rendered on the pod spec via `mintel_common.imagePullSecrets` (root `imagePullSecrets` and/or `global.imagePullSecrets`).
- Applied to: main Deployment/StatefulSet, deployment-celery, deployment-celery-beat, cronjobs (per-job `.image` or default), jobs (per-job image or jobDefaults.image), and client/exporter deployments when they don’t override.

---

### 1.4 Setting container command, args, and env

**Variables:** `command`, `args`, `env`, `main.env`, `envFrom`

**Logic (implementation detail):**

- Main container: `command` and `args` from root values; env from merge of `env` and `main.env`; `envFrom` for secret/configmap refs. Same pattern for celery/celery-beat with optional overrides.
- CronJobs: per-job `command`, `args`, `env`; optional `includeBaseEnv`, `includeMailhogEnv`, `includeRedisEnv`, etc. (see defaultEnv/localDevEnv helpers).
- Jobs: merged `jobDefaults` + job; `command`, `args`, `env`, `envFrom`; `includeBaseEnv` pulls in main workload env.

---

### 1.5 Configuring resource requests and limits

**Variables:** `resources` (limits, requests)

**Logic (implementation detail):**

- Main container uses `Values.resources` (with block `{{- with .Values.resources }}`).
- Celery, celery-beat, jobs, cronjobs (per-job), and client/metrics deployments have their own resources (e.g. `celery.resources`, `job.resources`). VPA `verticalPodAutoscaler.instances` can override per workload (e.g. celery, aws-es-proxy, mysqlclient).

---

### 1.6 Configuring liveness and readiness probes

**Variables:** `liveness` (enabled, methodOverride, path, port, scheme, initialDelaySeconds, periodSeconds, timeoutSeconds, failureThreshold, successThreshold, startup), `readiness` (same), `terminationGracePeriodSeconds`

**Logic (implementation detail):**

- When liveness is **disabled** (`liveness.enabled` false): Deployment metadata gets annotation `app.mintel.com/opa-skip-liveness-probe-check.main: "true"` (so OPA does not require a liveness probe for the main container).
- When readiness is **disabled**: annotation `app.mintel.com/opa-skip-readiness-probe-check.main: "true"`.
- Same OPA probe-skip annotations exist for filebeat sidecar (readiness; and when filebeat.metrics enabled, beat-exporter liveness/readiness) and git-sync (readiness). Celery, celery-beat, and client/exporter deployments have their own OPA probe annotations where applicable (e.g. opa-allow-single-replica, opa-skip-readiness-probe-check, opa-skip-security-context-check).
- `terminationGracePeriodSeconds` is set on the pod spec; it must be greater than `ingress.alb.preStopDelay.delaySeconds` when preStop delay is used for ALB deregistration.

---

### 1.7 Configuring security context

**Variables:** `securityContext`, `podSecurityContext`

**Logic (implementation detail):**

- Pod: `podSecurityContext` (or per-template override) on `spec.template.spec.securityContext`.
- Container: `securityContext` (or per-container override) via `with .securityContext | default $.Values.securityContext`. Celery, celery-beat, filebeatSidecar, gitSyncSidecar, oauthProxy, opensearch.awsEsProxy, mariadb/postgresql client and metrics deployments can override. Some exporter deployments set `app.mintel.com/opa-skip-security-context-check: "true"` on the pod template where they need to bypass strict security context checks.

---

### 1.8 Configuring rollout strategy

**Variables:** `strategy.type`, `strategy.maxSurge`, `strategy.maxUnavailable`, `minReadySeconds`

**Logic (implementation detail):**

- When `singleReplicaOnly` is true: only `strategy.type: Recreate` is emitted (no rollingUpdate).
- Otherwise: `strategy` block from values; type defaults to RollingUpdate; if type is RollingUpdate and maxSurge or maxUnavailable are set, `rollingUpdate` is included.
- StatefulSet always gets `updateStrategy.type: RollingUpdate` and `serviceName: fullname`.
- `minReadySeconds` is rendered only when **not** statefulset (see 1.2).

---

### 1.9 Adding init containers and extra containers

**Variables:** `extraInitContainers`, `extraContainers`

**Logic (implementation detail):**

- `extraInitContainers` rendered under `spec.template.spec.initContainers`.
- `extraContainers` rendered as additional containers in the pod (e.g. oauth2-proxy). CronJobs can have `extraInitContainers` per job; Jobs use `job.extraInitContainers` or jobDefaults.

---

### 1.10 Adding volumes and mounts

**Variables:** `volumes`, `volumeMounts`, `persistentVolumes`

**Logic (implementation detail):**

- `volumes` and `volumeMounts` are rendered on the pod spec. When statefulset is true, `persistentVolumes` become `volumeClaimTemplates` only; when statefulset is false, `persistentVolumes` also produce standalone PVCs in `pvcs.yaml` (see 1.2).

---

### 1.11 Running with only CronJobs or only Jobs

<!-- feature: workload.cronjobs-only-jobs-only -->

**Variables:** `cronjobsOnly`, `jobsOnly`

**Configure:**

- **CronJobs only (no main workload):** Set `cronjobsOnly: true` and configure `cronjobs.jobs`.
- **One-off Jobs only (no main workload):** Set `jobsOnly: true` and configure `jobs` / `jobDefaults`.

**Constraints and interactions:**

- When **either** is true, the main Deployment/StatefulSet, Service, main PDB, main VPA, and main ServiceMonitor are not rendered.
- See also section 6.3 (cross-reference only).

**Chart behavior:**

- Suppresses main workload and its dependent resources; CronJobs and/or Jobs still render per their own configuration.

---

### 1.12 Configuring pod metadata and extra ports

<!-- feature: workload.pod-metadata -->

**Variables:** `podAnnotations`, `priorityClassName`, `useHostNetwork`, `extraPorts`, `port`

**Configure:**

- **Extra container ports:** Set `extraPorts` (list of `name`, `containerPort`, optional `protocol`). Requires `port` to be set (non-null) on the main container.
- **Pod priority:** Set `priorityClassName` to an existing PriorityClass name (non-local clusters only).
- **Host network:** Set `useHostNetwork: true` to attach the pod to the node network namespace.
- **Custom pod annotations:** `podAnnotations` is defined in `values.yaml` but is **not currently wired** into deployment templates; do not rely on it until chart support is added.

**Constraints and interactions:**

- `extraPorts` are added to both the main container and the Service when `service.enabled` is true.
- `priorityClassName` is only applied when `global.clusterEnv` != `"local"`.

**Chart behavior:**

- Main Deployment/StatefulSet pod spec and Service port list.

---

### 1.13 Configuring lifecycle hooks and ALB preStop delay

<!-- feature: workload.lifecycle -->

**Variables:** `lifecycle`, `ingress.enabled`, `ingress.alb.preStopDelay.enabled`, `ingress.alb.preStopDelay.delaySeconds`, `terminationGracePeriodSeconds`

**Configure:**

- **ALB zero-downtime rollouts (default):** With `ingress.enabled: true`, `ingress.alb.preStopDelay.enabled` defaults to `true` and adds a `preStop` sleep of `ingress.alb.preStopDelay.delaySeconds` (default `15`) before container shutdown.
- **Custom lifecycle hooks:** Set `lifecycle` (e.g. `preStop`, `postStart`) when ALB preStop delay is **not** active.
- **Grace period:** Set `terminationGracePeriodSeconds` (default `30`); must be **greater than** `ingress.alb.preStopDelay.delaySeconds` when preStop delay is enabled.

**Constraints and interactions:**

- ALB preStop delay and custom `lifecycle` are **mutually exclusive**: when `ingress.enabled` and `ingress.alb.preStopDelay.enabled` are both true, the chart emits the ALB preStop hook and ignores `lifecycle`.
- When `ingress.enabled` is false, only `lifecycle` from values is used (if set).
- OAuth proxy sidecar uses the same lifecycle helper (see section 2.7).

**Chart behavior:**

- Main container `lifecycle` block on Deployment/StatefulSet.
- Sources: `templates/helpers/_deployment.yaml`

---

### 1.14 Celery and Celery Beat workloads

<!-- feature: workload.celery -->

**Variables:** `celery.enabled`, `celery.replicas`, `celery.image`, `celery.command`, `celery.args`, `celery.env`, `celery.resources`, `celery.liveness`, `celery.readiness`, `celery.startup`, `celery.metrics`, `celery.podDisruptionBudget`, `celeryBeat.enabled`, `celeryBeat.image`, `celeryBeat.command`, `celeryBeat.args`, `celeryBeat.env`, `celeryBeat.resources`, `celeryBeat.liveness`, `celeryBeat.readiness`, `celeryBeat.podSecurityContext`

**Configure:**

- **Celery workers:** Set `celery.enabled: true`, `celery.replicas`, and optionally override `celery.args` (default `["celery"]`), `celery.resources`, probes, and `celery.env`.
- **Celery Beat scheduler:** Set `celery.enabled: true`, `celeryBeat.enabled: true`, and optionally override `celeryBeat.args` (default `["celerybeat"]`).
- **Celery metrics:** `celery.metrics.enabled` (default `true`) exposes a metrics port; requires `redis.enabled` for the celery-exporter VPA/PodMonitor path.
- **Celery PDB:** `celery.podDisruptionBudget.enabled` (default `true`) with `minAvailable` (default `50%`).

**Constraints and interactions:**

- Celery uses the main `image` by default; does **not** inherit `main.env` (only `celery.env` and shared defaultEnv helpers).
- Celery Beat requires `celery.enabled: true`.
- OPA probe-skip annotations are applied when celery/celery-beat liveness or readiness is disabled.
- Celery PDB is created when `celery.enabled`, `celery.replicas` > 1, and `celery.podDisruptionBudget.enabled`.
- VPA instances: `verticalPodAutoscaler.instances.celery`, `.celery-beat`, `.celery-exporter` (see section 3.3).
- Celery deployments are independent of `cronjobsOnly` / `jobsOnly` (main workload hidden, celery still renders if enabled).

**Chart behavior:**

- `deployment-celery.yaml`, `deployment-celery-beat.yaml`, celery PDB, celery ServiceMonitor/PodMonitor, celery VPA instances.

---

## 2. Service and networking

### 2.1 Enabling or disabling the Service

<!-- feature: networking.service -->

**Variables:** `service.enabled`, `service.type`, `service.annotations`, `service.labels`, `port`

**Logic (implementation detail):**

- Service is rendered only when `service.enabled` is true **and** `cronjobsOnly` and `jobsOnly` are both false.
- When service is disabled and metrics are enabled: no Service is created; PodMonitor is used instead of ServiceMonitor (service-monitor.yaml is gated on `service.enabled`).
- Port: `service.port` and `service.targetPort` default to `Values.port` when not set.
- When `ingress.enabled` is true, Service gets ALB tags annotation (`alb.ingress.kubernetes.io/tags`) from backstage.component or else Owner/Application. When `nlb.enabled` is true, Service gets NLB annotations and `type: LoadBalancer`, `loadBalancerClass: service.k8s.aws/nlb`.

---

### 2.2 Configuring an ingress for direct public access

<!-- feature: networking.ingress -->

**Variables:** `ingress.enabled`, `ingress.tls`, `ingress.defaultHost`, `ingress.extraHosts`, `ingress.extraIngresses`, `ingress.extraAnnotations`, `ingress.allowLivenessUrl`, `ingress.allowReadinessUrl`, `ingress.alb` (scheme, backendProtocol, backendProtocolVersion, targetGroupAttributes, preStopDelay, healthcheck)

**Logic (implementation detail):**

- **Rendering:** When `ingress.enabled` is true, one or more Ingress resources are created. If `global.clusterEnv` is `"local"`, a single simple Ingress is used (no ALB annotations, ssl-redirect false). Otherwise, the template iterates over `extraIngresses` prepended with the root ingress config; each gets ALB annotations from `mintel_common.ingress.alb_annotations`.
- **defaultHost (effective hostname):** Helper `mintel_common.ingress.defaultHost`: If `ingress.alb.scheme` is `"api"`, the effective defaultHost is `api.mintel.com` (prod) or `{clusterEnv}-api.mintel.com` (non-prod). Otherwise it is `ingress.defaultHost` as provided.
- **Rules:** Default rule host is that defaultHost; path defaults to `/` with pathType Prefix; backend service/port: when oauthProxy enabled, port 4180; else `Values.port`. `pathBasedRouting` can override paths per ingress; `extraHosts` add additional host rules (with optional pathBasedRouting per host). When oauthProxy.ingressHost is set, an extra host rule is added for that host to port 4180.
- **TLS:** When `ingress.tls` is true and (`global.ingressTLSSecrets` or `specificTlsHostsYaml`) is set, TLS block is generated; hosts are matched to TLS secrets by suffix (e.g. defaultHost and extraHosts names matched to keys in ingressTLSSecrets).
- **Deployment labels:** When `ingress.enabled` is true **or** `ingress.allowFrontendAccess` is true, the Deployment/StatefulSet (and its pod template) get label `tier: frontend`.
- **ALB healthcheck:** Default path is `/readiness` (or GRPC health path when backendProtocolVersion is GRPC); default port from oauthProxy (4180, see section 2.7) or opensearch awsEsProxy ingress port or `Values.port`. preStopDelay (lifecycle preStop, see section 1.13) is used for zero-downtime rollouts when configured.

---

### 2.3 Configuring an ingress for API gateway (path-based routing)

**Variables:** `ingress.alb.apiAppName`, `ingress.alb.apiTargetService`

**Logic (implementation detail):**

- The ALB condition annotation for API Gateway–style routing is rendered **only when** `ingress.alb.scheme` is `"api"` (not for `internet-facing` or `internal`). Template: `alb.ingress.kubernetes.io/conditions.{{ .alb.apiTargetService | default (include "mintel_common.fullname" .) }}` with value a JSON array for `x-app-path` header, values `["/{{ .alb.apiAppName | default (include "mintel_common.fullname" .) }}/*"]`. So apiTargetService and apiAppName default to fullname when unset.
- When scheme is `"api"`, the Ingress name gets suffix `-api-gw` (helper `mintel_common.ingressName`), and defaultHost is derived as in 2.2 (api.mintel.com or env-api.mintel.com).

---

### 2.4 Setting frontend tier without ingress

**Variables:** `ingress.allowFrontendAccess`

**Logic (implementation detail):**

- When `allowFrontendAccess` is true, the Deployment/StatefulSet metadata and pod template get label `tier: frontend` even if `ingress.enabled` is false (same condition as in 2.2: `(or (and .Values.ingress .Values.ingress.enabled) .Values.ingress.allowFrontendAccess)`).

---

### 2.5 Exposing the app via a Network Load Balancer

**Variables:** `nlb.enabled`, `nlb.scheme`, `nlb.targetType`, `nlb.healthcheck`, `nlb.defaultHost`

**Logic (implementation detail):**

- When `nlb.enabled` is true: Service gets `type: LoadBalancer`, `loadBalancerClass: service.k8s.aws/nlb`, and annotations from `mintel_common.nlb.annotations` (including external-dns hostname from `nlb.defaultHost`). Protocol TCP is set on the main port. NLB-specific healthcheck and scheme/targetType drive the annotation set.

---

### 2.6 Configuring network policy

**Variables:** `networkPolicy.enabled`, `networkPolicy.additionalAllowFroms`

**Logic (implementation detail):**

- NetworkPolicy is rendered only when `global.clusterEnv` != `"local"` and `networkPolicy.enabled` is true. Default policy allows ingress from pods in the same `app.kubernetes.io/part-of` group; `additionalAllowFroms` add extra peer rules (by name/selector and optional ports).

---

### 2.7 OAuth proxy sidecar

<!-- feature: networking.oauth-proxy -->

**Variables:** `oauthProxy.enabled`, `oauthProxy.image`, `oauthProxy.ingressHost`, `oauthProxy.issuerUrl`, `oauthProxy.emailDomain`, `oauthProxy.allowedGroups`, `oauthProxy.type`, `oauthProxy.scope`, `oauthProxy.secretSuffix`, `oauthProxy.secretNameOverride`, `oauthProxy.secretRefreshIntervalOverride`, `oauthProxy.secretStoreRefOverride`, `oauthProxy.skipAuthRegexes`, `oauthProxy.resources`, `oauthProxy.userIdClaim`, `oauthProxy.env`, `oauthProxy.localSecretValues`

**Configure:**

- **Enable auth proxy:** Set `oauthProxy.enabled: true`. Sidecar listens on port `4180` (auth) and `9090` (metrics).
- **Redirect URL host:** Set `oauthProxy.ingressHost` or rely on `ingress.defaultHost` for the OAuth callback URL.
- **Access control:** Set `oauthProxy.emailDomain`, `oauthProxy.allowedGroups`, and/or `oauthProxy.skipAuthRegexes` for path bypass rules (liveness/readiness paths are skipped automatically).
- **Local dev:** Use `oauthProxy.localSecretValues` when `global.clusterEnv` is `"local"`.

**Constraints and interactions:**

- Sidecar is **not rendered** when `global.clusterEnv` is `"local"`.
- When enabled, Ingress backends route to port `4180` instead of the app port; Service exposes auth-proxy and metrics ports.
- `oauthProxy.ingressHost` adds an extra Ingress host rule when set and different from other hosts.
- NetworkPolicy allows traffic to port `4180` when oauth proxy is enabled.
- OAuth secret is included in Stakater reloader annotation list; secret name defaults to `{fullname}-oauth`.
- See section 5.3 for ExternalSecret creation (when standard-application-stack manages backend secrets).

**Chart behavior:**

- OAuth proxy sidecar on main Deployment, Ingress rule changes, Service ports, NetworkPolicy, ServiceMonitor/PodMonitor metrics endpoint.
- Sources: `templates/_oauth-proxy.tpl`, `templates/deployment.yaml`, `templates/ingress.yaml`, `templates/service.yaml`

---

## 3. Scaling and resilience

### 3.1 Enabling autoscaling (KEDA)

<!-- feature: scaling.keda -->

**Variables:** `autoscaling.enabled`, `autoscaling.pollingInterval`, `autoscaling.cooldownPeriod`, `autoscaling.minReplicaCount`, `autoscaling.maxReplicaCount`, `autoscaling.enableZeroReplicas`, `autoscaling.scaleTargetRef`, `autoscaling.fallback`, `autoscaling.triggers`, `autoscaling.mimir`, `statefulset`

**Configure:**

- **Enable KEDA scaling:** Set `autoscaling.enabled: true` and configure `autoscaling.minReplicaCount` / `autoscaling.maxReplicaCount`. Do not rely on `replicas` (see section 1.1).
- **Scale to zero:** Set `autoscaling.enableZeroReplicas: true` (sets `idleReplicaCount: 0` on the ScaledObject).
- **CPU/memory triggers:** Set `autoscaling.triggers` fields such as `targetCPUUtilizationPercentage` or `targetMemoryUtilizationPercentage`.
- **Custom triggers:** Add entries to `autoscaling.triggers.custom` (Prometheus, AWS SQS/SNS, etc.).
- **Mimir/Prometheus:** Configure `autoscaling.mimir` when using Prometheus triggers against Mimir.

**Constraints and interactions:**

- ScaledObject is rendered only when `autoscaling.enabled` is true **and** `global.clusterEnv` != `"local"`.
- Chart clamps values: `cooldownPeriod` ≥ 60, `pollingInterval` ≥ 10, `maxReplicaCount` capped at 30, `minReplicaCount` capped at 10 (values above 10 become 2).
- `autoscaling.fallback.replicas` defaults to `minReplicaCount` when unset.
- `scaleTargetRef.kind` is `StatefulSet` when `statefulset: true`, else `Deployment`.
- Topology spread is skipped when both `autoscaling.enabled` and `enableZeroReplicas` are true (see section 1.1).
- For Prometheus triggers with Mimir enabled, the chart overrides server address and adds authentication ref.

**Chart behavior:**

- KEDA ScaledObject targeting the main workload; workload `replicas` field omitted when autoscaling is active.
- Sources: `templates/keda-scaled-object.yaml`

---

### 3.2 Configuring Pod Disruption Budget

**Variables:** `podDisruptionBudget.enabled`, `podDisruptionBudget.minAvailable`, `podDisruptionBudget.maxUnavailable`, `podDisruptionBudget.unhealthyPodEvictionPolicy`

**Logic (implementation detail):**

- **Main PDB:** Created only when helper `mintel_common.pdb.createPDB` returns `"true"` **and** `cronjobsOnly` and `jobsOnly` are false. createPDB is true when: `podDisruptionBudget.enabled` is true **and** (if autoscaling enabled then `autoscaling.minReplicaCount` > 1, else `replicas` > 1). So with replicas 1 or minReplicaCount 1, no main PDB.
- **Spec:** minAvailable or maxUnavailable from values (note: template spells it `maxUnvailable` in the emitted YAML—typo in pdbs.yaml). unhealthyPodEvictionPolicy is emitted only when set and when `semverCompare ">=1.31-0" .Capabilities.KubeVersion.GitVersion`.
- **Celery PDB:** Second PDB when `celery.enabled`, `celery.replicas` > 1, and `celery.podDisruptionBudget.enabled`; uses celery.podDisruptionBudget.minAvailable/maxUnavailable/unhealthyPodEvictionPolicy.

---

### 3.3 Configuring Vertical Pod Autoscaler

**Variables:** `verticalPodAutoscaler.enabled`, `verticalPodAutoscaler.autoscalingEnabled`, `verticalPodAutoscaler.minReplicas`, `verticalPodAutoscaler.containerPolicies`, `verticalPodAutoscaler.evictionRequirements`, `verticalPodAutoscaler.instances`

**Logic (implementation detail):**

- VPA manifests are rendered when `global.clusterEnv` != `"local"` and not (cronjobsOnly or jobsOnly). Each VPA (main workload, statefulset, aws-es-proxy, celery, celery-beat, celery-exporter, mysqlclient, mysqldexporter, postgresqlclient, postgresqlexporter) is gated by its own condition (e.g. opensearch.awsEsProxy enabled for aws-es-proxy). Config for each is `verticalPodAutoscaler.instances.<name> | default dict | mustMergeOverwrite (mustDeepCopy .Values.verticalPodAutoscaler)` so instance keys override the default verticalPodAutoscaler spec.

---

### 3.4 Configuring topology spread and affinity

**Variables:** `topologySpreadConstraints` (enabled, zone, node, specificYaml), `affinity` (enabled, podAntiAffinity, specificYaml)

**Logic (implementation detail):**

- **Topology spread:** Rendered only when not local, `replicas` > 1, and not (autoscaling.enabled and enableZeroReplicas). If `topologySpreadConstraints.specificYaml` is set, it is emitted as-is. Zone spread uses topologyKey `topology.kubernetes.io/zone`; node spread uses `kubernetes.io/hostname`. Node spread is also enabled when `topologySpreadConstraints.node.enabled` is not a bool and clusterEnv is logs or prod (default prod/logs get node spread). whenUnsatisfiable defaults to DoNotSchedule; matchLabelKeys can be enabled for zone/node.
- **Affinity:** Rendered on Deployment when `affinity.enabled` is true **and** `replicas` > 1. Pod anti-affinity (zone/node, hard/soft) and optional `affinity.specificYaml` are applied. Celery deployment uses the same condition (replicas > 1 and affinity.enabled).

---

## 4. Identity and RBAC

### 4.1 Service account and IRSA

**Variables:** `serviceAccount.create`, `serviceAccount.name`, `serviceAccount.annotations`, `serviceAccount.irsa` (enabled, nameOverride), `global.terraform.irsa`

**Logic (implementation detail):**

- When `serviceAccount.create` is true (or `serviceAccount.name` is set): ServiceAccount is created with that name or fullname. Annotations come from `serviceAccount.annotations`. When `global.terraform.irsa` is true, the EKS IRSA annotation (role-arn) is typically supplied by terraform-cloud output; `serviceAccount.irsa.nameOverride` overrides the last component of the role-arn. Pods use `serviceAccountName` from the ServiceAccount name. Jobs/CronJobs and py-dba jobs use the same ServiceAccount when serviceAccount.create/name is set.

---

### 4.2 Roles and ClusterRoles

**Variables:** `serviceAccount.roles`, `serviceAccount.clusterRoles`

**Logic (implementation detail):**

- When `serviceAccount.create` is true: Role and RoleBinding (and optionally ClusterRole/ClusterRoleBinding) resources are created from `serviceAccount.roles` and `serviceAccount.clusterRoles`; each role is bound to the ServiceAccount. Helper templates _role.yaml and _roleBinding.yaml (and cluster variants) render names and rules from the config.

---

### 4.3 Kubelock

**Variables:** `kubelock.enabled`, `kubelock.nameOverride`

**Logic (implementation detail):**

- Kubelock Role and RoleBinding are rendered when `serviceAccount.create` is true **and** `kubelock.enabled` is true. Jobs get kubelock-related env when `jobDefaults.kubelock.enabled` (or per-job kubelock.enabled) is true; Jobs that need kubelock use a distinct ServiceAccount name (fullname per job) so the RoleBinding can target them.

---

## 5. Secrets and backends (standard-application-stack)

### 5.1 Main app External Secret

<!-- feature: secrets.external-secret -->

**Variables:** `externalSecret.enabled`, `externalSecret.nameOverride`, `pathOverride`, `secretRefreshIntervalOverride`, `secretStoreRefOverride`, `localValues`, `extraSecrets`

**Logic (implementation detail):**

- When `externalSecret.enabled` is true: In **local** env, if `externalSecret.localValues` is set, a plain Secret is created (name `fullname-app`, data from localValues). In non-local env, an ExternalSecret is created: `dataFrom.extract.key` defaults to `{namespace}/{fullname}/app` (or pathOverride); refreshInterval and secretStoreRef use overrides or defaults (e.g. secretStoreRefOverride default `aws-secrets-manager-default`). Annotation `argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true` is set. extraSecrets iterate similarly (local: Secret from localValues; non-local: ExternalSecret with optional outputSecretMap). Stakater reloader annotation on Deployment uses `mintel_common.secretList` so the main app secret (and extraSecrets when includeInMain) are listed for reload.

---

### 5.2 Using Terraform-managed backend secrets

<!-- feature: secrets.terraform-external-secrets -->

**Variables:** `global.terraform.externalSecrets`, plus per-backend `enabled` and `outputSecret` on both charts

**Configure:**

- **Terraform Cloud manages backend secrets:** Set `global.terraform.externalSecrets: true` on the shared values object passed to **both** charts.
- **Enable a backend:** Set `.<backend>.enabled: true` (e.g. `mariadb.enabled`, `s3.enabled`) and `.<backend>.outputSecret: true` on the terraform-cloud chart side.
- **App still needs backend access:** On standard-application-stack, set the same backend `.enabled: true` so env/volumeMounts inject secret refs (chart does not create ExternalSecrets for backends when `externalSecrets` is true).

**Constraints and interactions:**

- When `global.terraform.externalSecrets` is true, standard-application-stack **does not** create ExternalSecrets for backend resources (mariadb, postgresql, redis, s3, dynamodb, elasticsearch, opensearch, etc.); terraform-cloud chart creates those.
- standard-application-stack still injects secret refs into the Deployment (and optional client/exporter workloads) so pods mount the secrets that terraform-cloud's ExternalSecrets have created.
- Both charts must receive consistent `global` and backend `enabled` flags.

**Chart behavior:**

- terraform-cloud: `workspace-output-secret.yaml` ExternalSecrets per enabled resource with `outputSecret: true`.
- standard-application-stack: secret refs in Deployment env/volumeMounts only (no backend ExternalSecrets).

---

### 5.3 MariaDB / PostgreSQL / Redis / S3 / DynamoDB / SQS / Elasticsearch / OpenSearch

**Variables:** Per-backend: `enabled`, `outputSecret`, overrides (secretNameOverride, pathOverride, secretRefreshIntervalOverride, secretStoreRefOverride), and backend-specific (e.g. mariadb.client, mariadb.metrics, mariadb.extraUsers; opensearch.awsEsProxy).

**Logic (implementation detail):**

- Each backend's ExternalSecret (when standard-application-stack creates it) is gated on: `externalSecret.enabled`, **not** `global.terraform.externalSecrets`, and (for non-local) the appropriate backend `.enabled` and path/secretStoreRef. In local env, some backends may use localValues or be skipped. Deployment env/volumeMounts reference the secret name (fullname-based or override). MariaDB/PostgreSQL: client and metrics deployments when enabled; extraUsers enables mariadb-py-dba or postgresql-py-dba Job. OpenSearch: when awsEsProxy enabled, proxy Deployment/Service/Ingress/NetworkPolicy and VPA are created; proxy has OPA annotations (opa-allow-single-replica, opa-skip-readiness-probe-check, opa-skip-security-context-check). For OAuth proxy configuration see section 2.7.

---

## 6. Scheduled and one-off workloads

### 6.1 CronJobs

**Variables:** `cronjobs.jobs`, `cronjobs.defaults` (concurrencyPolicy, restartPolicy, suspend, ttlSecondsAfterFinished, timezone, enableDoNotDisrupt, backoffLimit)

**Logic (implementation detail):**

- One CronJob per entry in `cronjobs.jobs`. Each job merges with defaults: concurrencyPolicy, suspend, schedule, timezone, restartPolicy, ttlSecondsAfterFinished, backoffLimit (nil uses Kubernetes default 6 if not set in defaults). **Annotation:** When `cronjobs.defaults.enableDoNotDisrupt` is true, the **jobTemplate.spec.template.metadata.annotations** include `karpenter.sh/do-not-disrupt: "true"` (no per-job override in template—uses defaults only). Per-job overrides: image, command, args, env, resources, include*Env, include*Secret, podSecurityContext, extraInitContainers.

---

### 6.2 One-off Jobs

**Variables:** `jobs`, `jobDefaults` (name, command, args, env, envFrom, image, resources, includeAppSecret, includeBaseEnv, includeBasePodSecurityContext, enableDoNotDisrupt, restartPolicy, ttlSecondsAfterFinished, backoffLimit, kubelock, irsa, argo, extraInitContainers)

**Logic (implementation detail):**

- One Job per entry in `jobs`; each is merged with `jobDefaults` via mergeOverwrite. **Annotation:** When the merged job’s `enableDoNotDisrupt` is true, the pod **template.metadata.annotations** include `karpenter.sh/do-not-disrupt: "true"`. So this can be set per job or via jobDefaults. Argo hook/syncWave from job.argo; serviceAccountName is set to the job fullname when ServiceAccount is created (for RoleBinding to job-specific SA when kubelock/irsa enabled).

---

### 6.3 Hiding the main deployment

<!-- feature: workloads.hide-main-deployment -->

**Variables:** `cronjobsOnly`, `jobsOnly`

See section 1.11 for full configuration, constraints, and chart behavior. This section exists as a cross-reference from the scheduled/one-off workloads chapter.

---

## 7. Observability and instrumentation

### 7.1 Prometheus metrics (ServiceMonitor / PodMonitor)

**Variables:** `metrics.enabled`, `metrics.interval`, `metrics.path`, `metrics.port`, `metrics.timeout`, `metrics.scheme`, `metrics.basicAuth`, `metrics.additionalMonitors`

**Logic (implementation detail):**

- ServiceMonitor is rendered when: `service.enabled`, not cronjobsOnly/jobsOnly, `global.clusterEnv` != `"local"`, and `metrics.enabled`. PodMonitor is used when service is disabled and metrics enabled (pod-monitor.yaml). additionalMonitors produce extra monitor manifests. Interval/path/port/timeout/scheme and basicAuth (secretName, usernameKey, passwordKey) are passed to the monitor spec.

---

### 7.2 OpenTelemetry

**Variables:** `otel.exporter.endpoint`, `otel.sampler`, `otel.extraEnv`, `otel.python.*`, `otel.java.*`

**Logic (implementation detail):**

- OTEL env vars are injected into the main Deployment (and optionally celery) via helper _instrumentation.yaml; exporter endpoint, sampler type/arg, and language-specific (python/java) vars are set so the app can send traces to the configured endpoint.

---

## 8. Sidecars and local dev

### 8.1 Filebeat sidecar

**Variables:** `filebeatSidecar.enabled`, resources, configmap, `filebeatSidecar.metrics`

**Logic (implementation detail):**

- When enabled, an extra container is added to the main pod; when filebeatSidecar.metrics enabled, beat-exporter ports (9479) are added to the Service and PodMonitor may be created. Deployment gets OPA annotations to skip readiness/liveness for filebeat and beat-exporter when applicable. ConfigMap for filebeat config is created when configmap is provided.

---

### 8.2 Git-sync sidecar

**Variables:** `gitSyncSidecar.enabled`, `repo`, `branch`, `root`, `dest`, resources`

**Logic (implementation detail):**

- When enabled, an init container (or sidecar) runs git-sync with args from repo, branch, root, dest; a volume is mounted at `root`. Deployment gets `app.mintel.com/opa-skip-readiness-probe-check.git-sync: "true"`.

---

### 8.3 Localstack / Mailhog / Event Bus

**Variables:** `localstack.enabled`, `mailhog.enabled`, `eventBus.enabled` (+ eventBus accountId, region, serviceName, maxWorkers, interactiveApp)

**Logic (implementation detail):**

- Env vars for localstack (and optional configmap-localstack when local env), mailhog, and event bus are injected via defaultEnv/localDevEnv helpers so the main container (and optionally cronjobs/jobs via include*Env) can reach these services.

---

## 9. Entra and ConfigMaps

### 9.1 Entra (Azure AD) Application and Service Principal

**Variables:** `entra.enabled`, `displayName`, `description`, `redirectURIs`, `owners`, `groupMembershipClaims`, `extraResourceAccess`, `appRoleAssignmentRequired`, `visibleToUsers`, `createIngressRBAC`, `developmentMode`, `includeClientSecretsInWorkload`

**Logic (implementation detail):**

- When `entra.enabled`: Entra Application, ServicePrincipal, and PasswordCredentials CRs are created. Application and ServicePrincipal CRs are only rendered when clusterEnv is set and (developmentMode is true or clusterEnv is prod). When `createIngressRBAC` is true, a Role and RoleBinding are created so the ingress controller can read the Entra client secret. When `includeClientSecretsInWorkload` is true, AZURE_* client secret env vars are added to the main workload (via secretList/env).

---

### 9.2 ConfigMaps

**Variables:** `configMaps` (name, create, argo, configs)

**Logic (implementation detail):**

- For each entry with `create: true`, a ConfigMap is created with configs (name/data). Argo annotations (hook, hookDeletePolicy, syncWave) applied when set. Deployment gets configmap.reloader.stakater.com/reload annotation listing these ConfigMaps when present (from mintel_common.configmapList).

---

## 10. Terraform Cloud (infrastructure as code)

### 10.1 Enabling a Terraform Cloud resource type

<!-- feature: terraform-cloud.resource -->

**Variables:** Per resource: `enabled`, `terraform.module.source`, `terraform.module.version`, `terraform.terraformVersion`, `terraform.defaultVars`, `terraform.instances`, `syncWave`, `outputSecret`, `eventBus.enabled` (SNS/SQS)

**Logic (implementation detail):**

- For each resource type in terraformCloudResources (e.g. activeMQ, s3, mariadb, dynamodb, irsa, …): when `.<resource>.enabled` is true, workspace.yaml renders one Workspace CR and one Module CR per instance (from `terraform.instances` map or a default instance). defaultVars are merged with instance vars. global.terraform provides organization, agentPoolID, executionMode, terraformVersion, defaultApplyMethod, defaultWorkspaceAllowDestroy, enableRestartedAt, restartedAt, teamAccess, tags. allow_destroy default: from instance workspaceAllowDestroy, else global defaultWorkspaceAllowDestroy, else false for prod/logs and true otherwise. defaultVarValues helper injects env-based defaults (e.g. RDS backup/multi_az/deletion_protection; DynamoDB point_in_time_recovery; OpenSearch instance_count/zone_awareness; Redis replication_group_size; S3 enable_versioning). Workspace annotations include app.mintel.com/terraform-allow-destroy, terraform-cloud-tags, terraform-owner. outputSecret and syncWave control ExternalSecret rendering and Argo sync wave.

---

### 10.2 Outputting workspace outputs to Kubernetes secrets

**Variables:** `global.terraform.externalSecrets`, `.<resource>.outputSecret`, `.<resource>.terraform.instances` (and defaultVars for outputSecretMap)

**Logic (implementation detail):**

- workspace-output-secret.yaml is rendered only when `global.terraform.externalSecrets` is true. For each resource type where `.<resource>.enabled` and `.<resource>.outputSecret` are true, ExternalSecret(s) are emitted for that resource’s outputs (one per instance or default). outputSecretMap on the instance/defaultVars remaps secret keys. IRSA ExternalSecret is created when `irsa.terraform.vars.output_secret_name` is set.

---

### 10.3 IRSA via Terraform Cloud

**Variables:** `irsa.enabled`, `irsa.terraform.*` (module, vars, notifications, nameOverride), `irsa.terraform.vars.output_secret_name`, `jobs`, `s3MultiRegionAccessPoint.enabled` + instances

**Logic (implementation detail):**

- irsa-workspace.yaml is rendered when `irsa.enabled` is true **or** helper `mintel_common.terraform_cloud.irsaRequired` returns true (any of opensearch, s3, s3MultiRegionAccessPoint, dynamodb, sns, sqs has `.enabled`). IRSA Workspace and Module CRs are created; vars include k8s_service_account_name and optional k8s_extra_service_accounts built from `jobs` (fullname + job name). When s3MultiRegionAccessPoint is enabled, vars get lookup_multi_region_access_points from s3MultiRegionAccessPoint.terraform.instances. When output_secret_name is set and externalSecrets is true, one ExternalSecret for IRSA output is created.

---

### 10.4 Global Terraform settings

**Variables:** `global.terraform.organization`, `agentPoolID`, `executionMode`, `terraformVersion`, `enableRestartedAt`, `restartedAt`, `defaultWorkspaceAllowDestroy`, `defaultApplyMethod`, `teamAccess`, `tags` (addBackstageComponentTag, addDeprecatedTags)

**Logic (implementation detail):**

- Applied to all Workspace/Module CRs. defaultTags helper adds backstage.io/component (when addBackstageComponentTag and backstage.component set) and deprecated Owner/Project/Application/Component from global. allow_destroy defaults from defaultWorkspaceAllowDestroy or from clusterEnv (prod/logs → false). restartedAt in Module CR when enableRestartedAt is true (value from restartedAt or hash of instance config).

---

## 11. Naming and labels

### 11.1 Application name and fullname

<!-- feature: naming.fullname -->

**Variables:** `global.name`, `nameOverride`, `partOf`, `component` (root and global), `global.application`, `global.component`, `global.owner`, `global.partOf`, `global.additionalLabels`, `additionalLabels`

**Logic (implementation detail):**

- **fullname:** If `nameOverride` is set, it is used (truncated to 63 chars). Else if a component is in context (e.g. celery, job name), `{global.name}-{component}` with Chart name suffix trimmed. Else `global.name`. Used for resource names and selectors.
- **Selector labels:** `app.kubernetes.io/name`: fullname; `app.kubernetes.io/part-of`: partOf or global.partOf; `app.kubernetes.io/component`: component or global.component or "app".
- **Common labels:** app.mintel.com/owner, application (default global.name), component (default global.name), env (clusterEnv), region (clusterRegion or "${CLUSTER_REGION}" non-local), plus global.additionalLabels and root additionalLabels. Both charts consume the same global for consistency.
