# standard-application-stack

![Version: 10.3.0](https://img.shields.io/badge/Version-10.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A generic chart to support most common application requirements

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | 11.0.10 |
| https://charts.bitnami.com/bitnami | postgresql | 11.6.3 |
| https://charts.bitnami.com/bitnami | redis | 16.11.2 |
| https://codecentric.github.io/helm-charts | mailhog | 4.1.0 |
| https://helm.elastic.co | elasticsearch | 7.5.2 |
| https://helm.elastic.co | kibana | 7.5.2 |
| https://localstack.github.io/helm-charts | localstack | 0.3.5 |
| https://opensearch-project.github.io/helm-charts | opensearch | 1.4.2 |
| https://opensearch-project.github.io/helm-charts | opensearch-dashboards | 1.0.8 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{"enabled":false,"podAntiAffinity":{"node":"soft","zone":"hard"}}` | Configure the deployment affinity/anti-affinity rules ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| affinity.enabled | bool | `false` | Set to true to enable deployment affinity rules |
| affinity.podAntiAffinity | object | `{"node":"soft","zone":"hard"}` | Configure pod anti-affinity rules |
| affinity.podAntiAffinity.node | string | `"soft"` | Toggle whether node affinity should be required (hard) or preferred (soft) |
| affinity.podAntiAffinity.zone | string | `"hard"` | Toggle whether zone affinity should be required (hard) or preferred (soft) |
| allowSingleReplica | bool | `false` | Explicitly allow the number of replicas to equal 1 Useful for backend event based services where we may only want a single replica but still want rolling updates etc |
| args | list | `[]` | Optional arguments to the container |
| autoscaling | object | `{"advanced":{},"cooldownPeriod":300,"enableZeroReplicas":false,"enabled":false,"fallback":{"failureThreshold":3},"maxReplicaCount":5,"minReplicaCount":2,"pollingInterval":30,"scaleTargetRef":{"apiVersion":"apps/v1","envSourceContainerName":"","kind":"Deployment"},"triggers":{}}` | Handle autoscaling via https://keda.sh Creates a ScaledObject for the workload ref: https://keda.sh/docs/2.8/concepts/scaling-deployments/ |
| celery | object | `{"args":["celery"],"enabled":false,"liveness":{"enabled":false},"metrics":{"enabled":true,"port":"metrics"},"podDisruptionBudget":{"enabled":true,"minAvailable":"50%","unhealthyPodEvictionPolicy":"AlwaysAllow"},"readiness":{"enabled":false},"replicas":2,"resources":{"limits":{},"requests":{}},"startup":{"failureThreshold":60,"methodOverride":{},"periodSeconds":5}}` | Configure celery deployment Defaults to same image as main deployment but with the "celery" argument |
| celery.args | list | `["celery"]` | Arguments to the celery container |
| celery.enabled | bool | `false` | Set to true to enable a celery deployment |
| celery.liveness | object | `{"enabled":false}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.liveness.enabled | bool | `false` | Enable liveness probe |
| celery.metrics | object | `{"enabled":true,"port":"metrics"}` | Prometheus Exporter / Metrics |
| celery.metrics.enabled | bool | `true` | Enable Prometheus to access application metrics endpoints |
| celery.metrics.port | string | `"metrics"` | Port to collect celery metrics |
| celery.podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%","unhealthyPodEvictionPolicy":"AlwaysAllow"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| celery.podDisruptionBudget.unhealthyPodEvictionPolicy | string | `"AlwaysAllow"` | Controls how Pod Disruption Budgets apply to pods that are unhealthy.    The default is to allow them to be terminated. |
| celery.readiness | object | `{"enabled":false}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.readiness.enabled | bool | `false` | Enable readiness probe |
| celery.replicas | int | `2` | Desired number of replicas for celery deployment |
| celery.resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits |
| celery.resources.limits | object | `{}` | The resource limits for the container |
| celery.resources.requests | object | `{}` | The requested resources for the container |
| celery.startup | object | `{"failureThreshold":60,"methodOverride":{},"periodSeconds":5}` | Configure extra options for the start-up probe that is enabled when celery.liveness.enabled is set to true |
| celery.startup.failureThreshold | int | `60` | The number of times the start-up probe is allowed to fail before the pod is deemed to have failed to start. |
| celery.startup.methodOverride | object | `{}` | Allows a non-default startup probe implementation |
| celery.startup.periodSeconds | int | `5` | The period of time to wait for an individual run of the start-up check to complete. |
| celeryBeat | object | `{"args":["celerybeat"],"enabled":false,"liveness":{"enabled":false},"readiness":{"enabled":false},"resources":{"limits":{},"requests":{}}}` | Configure celerybeat deployment Defaults to same image as main deployment but with the "celerybeat" argument |
| celeryBeat.args | list | `["celerybeat"]` | Optional command to the celery container  command: [] |
| celeryBeat.enabled | bool | `false` | Set to true to enable a celerybeat deployment |
| celeryBeat.liveness | object | `{"enabled":false}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celeryBeat.liveness.enabled | bool | `false` | Enable liveness probe |
| celeryBeat.readiness | object | `{"enabled":false}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celeryBeat.readiness.enabled | bool | `false` | Enable readiness probe |
| celeryBeat.resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits |
| celeryBeat.resources.limits | object | `{}` | The resource limits for the container |
| celeryBeat.resources.requests | object | `{}` | The requested resources for the container |
| command | list | `["/app/docker-entrypoint.sh"]` | Optional command to the container |
| configMaps | list | `[]` | A list of configuration maps for this application |
| cronjobs | object | `{"defaults":{"concurrencyPolicy":"Forbid","enableDoNotDisrupt":true,"restartPolicy":"Never","suspend":false,"timezone":null,"ttlSecondsAfterFinished":60},"jobs":[]}` | Define and Configure CronJob's Defaults to same image as main deployment but with defined arguments |
| cronjobs.defaults | object | `{"concurrencyPolicy":"Forbid","enableDoNotDisrupt":true,"restartPolicy":"Never","suspend":false,"timezone":null,"ttlSecondsAfterFinished":60}` | Defaults for all CronJob's |
| cronjobs.defaults.concurrencyPolicy | string | `"Forbid"` | Tells controller how to handle concurrent executions of a CronJob ref: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/#CronJobSpec |
| cronjobs.defaults.enableDoNotDisrupt | bool | `true` | Whether to set the `karpenter.sh/do-not-disrupt`annotation on the CronJob |
| cronjobs.defaults.restartPolicy | string | `"Never"` | Configure CronJob pod restart Policy ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| cronjobs.defaults.suspend | bool | `false` | Tells controller to suspend future executions ref: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/#CronJobSpec |
| cronjobs.defaults.timezone | string | `nil` | CronJob schedule will run relative to this timezone. ref: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones |
| cronjobs.defaults.ttlSecondsAfterFinished | int | `60` | If this field is set, ttlSecondsAfterFinished after the Job finishes, it is eligible to be automatically deleted. ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#cronjob-v1beta1-batch |
| cronjobs.jobs | list | `[]` | List of Cronjob configurations to be defined |
| cronjobsOnly | bool | `false` | Only show Cronjobs and relevant resources (i.e. if set to `true`, hide the main deployment resource) |
| dynamodb.enabled | bool | `false` |  |
| dynamodb.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| elasticsearch.enabled | bool | `false` |  |
| elasticsearch.secretRefreshIntervalOverride | string | `""` | Optional: ExternalSecret refreshInterval override |
| elasticsearch.secretStoreRefOverride | string | `""` | Optional: override the SecretStoreRef of the ExternalSecret |
| entra | object | `{"appRoleAssignmentRequired":true,"createIngressRBAC":true,"description":"","displayName":"","enabled":false,"extraResourceAccess":[],"groupMembershipClaims":[],"includeClientSecretsInWorkload":false,"owners":[],"redirectURIs":[],"visibleToUsers":true}` | Configure entra Application and Password Credentials |
| entra.appRoleAssignmentRequired | bool | `true` | Optional: If true (default), ServicePrincipal will require app role assignment. Set to false to disable. |
| entra.createIngressRBAC | bool | `true` | Optional: If true, create the role/role-bindings to allow the ingress-controller to read Entra client-secrets |
| entra.description | string | `""` | Required: Description of the application |
| entra.displayName | string | `""` | Required: Display Name of the application |
| entra.enabled | bool | `false` | Set to true to configure Entra resources |
| entra.extraResourceAccess | list | `[]` | Optional: A list of additional ResourceAccess settings (for Microsoft Graph only) |
| entra.groupMembershipClaims | list | `[]` | Optional: A list groupMembershipClaims (defaults to ["None"]) |
| entra.includeClientSecretsInWorkload | bool | `false` | Optional: If true, include Entra (AZURE_) client-secrets as env-vars in main workload |
| entra.owners | list | `[]` | Optional: A list owner group-ids |
| entra.redirectURIs | list | `[]` | Optional: A list of redirectURIs |
| entra.visibleToUsers | bool | `true` | Optional: If true (default), ServicePrincipal will be visible to users. Set to false to disable. |
| env | list | `[]` | Optional environment variables injected into container(s) NOTE: This is used across multiple deployments. |
| envFrom | list | `[]` | Optional environment variables injected into the container using envFrom (secrets/configmaps) |
| eventBus | object | `{"accountId":"","enabled":false,"interactiveApp":false,"maxWorkers":1,"region":"us-east-2","serviceName":""}` | Configure connection to the Event Bus |
| eventBus.accountId | string | `""` | Required: AWS account ID where the Event Bus is located |
| eventBus.enabled | bool | `false` | Set to true to set Event Bus environment variables |
| eventBus.interactiveApp | bool | `false` | Whether or not app is considered interactive |
| eventBus.maxWorkers | int | `1` | Max number of workers |
| eventBus.region | string | `"us-east-2"` | AWS region where Event Bus is located |
| eventBus.serviceName | string | `""` | Required: Which service to use |
| externalSecret | object | `{"enabled":true}` | Define ExternalSecret from AWS ref: https://github.com/external-secrets/kubernetes-external-secrets |
| extraContainers | list | `[]` | Enable extraContainers (oauth2-proxy is a common example) |
| extraInitContainers | list | `[]` | Enable extra init-containers |
| extraPorts | list | `[]` | Optional list of extra container ports to configure |
| extraSecrets | list | `[]` |  |
| filebeatSidecar.enabled | bool | `false` |  |
| filebeatSidecar.metrics.enabled | bool | `true` |  |
| filebeatSidecar.metrics.resources.limits.memory | string | `"200Mi"` |  |
| filebeatSidecar.metrics.resources.requests.cpu | string | `"10m"` |  |
| filebeatSidecar.metrics.resources.requests.memory | string | `"100Mi"` |  |
| filebeatSidecar.resources.limits.memory | string | `"200Mi"` |  |
| filebeatSidecar.resources.requests.cpu | string | `"10m"` |  |
| filebeatSidecar.resources.requests.memory | string | `"100Mi"` |  |
| gitSyncSidecar | object | `{"branch":"main","enabled":false,"resources":{"limits":{"memory":"200Mi"},"requests":{"cpu":"50m","memory":"50Mi"}},"root":"/data/git-sync"}` | Helper to sync a local directory with Git ref: https://github.com/kubernetes/git-sync |
| gitSyncSidecar.branch | string | `"main"` | The git branch to check out |
| global | object | `{"additionalLabels":{},"application":"","cloudProvider":{"accountId":"","region":""},"clusterDomain":"127.0.0.1.nip.io","clusterEnv":"local","clusterName":"","component":"","ingressTLSSecrets":{},"name":"example-app","owner":"","partOf":"","runtimeEnvironment":"kubernetes","terraform":{"externalSecrets":false,"irsa":false}}` | Global variables for us in all charts and sub charts |
| global.additionalLabels | object | `{}` | Additional labels to apply to all resources |
| global.application | string | `""` | Name of the application (defaults to global.name) |
| global.cloudProvider | object | `{"accountId":"","region":""}` | Global variables relating to cloud provider |
| global.cloudProvider.accountId | string | `""` | AWS Account Id |
| global.cloudProvider.region | string | `""` | AWS region name |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Kubernetes cluster domain |
| global.clusterEnv | string | `"local"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `""` | Kubernetes cluster name |
| global.component | string | `""` | Component of the application (defaults to global.name) |
| global.ingressTLSSecrets | object | `{}` | Global dictionary of TLS secrets |
| global.name | string | `"example-app"` | Name of the application |
| global.owner | string | `""` | Team which "owns" the application |
| global.partOf | string | `""` | Top level application each deployment is a part of |
| global.runtimeEnvironment | string | `"kubernetes"` | Global variable definint RUNTIME_ENVIRONMENT |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"","repository":"test","tag":"v0.0.0"}` | Docker image values |
| image.pullPolicy | string | `"IfNotPresent"` | Optional ImagePullPolicy ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images |
| image.registry | string | `""` | Docker registry used to pull application image |
| image.repository | string | `"test"` | Docker repository |
| image.tag | string | `"v0.0.0"` | Container image tag |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"alb":{"apiAppName":"","apiTargetService":"","backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing","targetGroupAttributes":{"deregistration_delay.timeout_seconds":5,"load_balancing.algorithm.type":"least_outstanding_requests"}},"allowFrontendAccess":false,"allowLivenessUrl":false,"allowReadinessUrl":false,"enabled":false,"extraAnnotations":{},"extraHosts":[],"extraIngresses":[],"specificRulesHostsYaml":{},"specificTlsHostsYaml":{},"tls":true}` | Configure the ingress resource that allows you to access the application from public-internet ref: http://kubernetes.io/docs/user-guide/ingress/ |
| ingress.alb.backendProtocol | string | `"HTTP"` | Application Version (HTTP / HTTPS) |
| ingress.alb.backendProtocolVersion | string | `"HTTP1"` | Application Protocol Version (HTTP1 / HTTP2 / GRPC) |
| ingress.alb.healthcheck.healthyThresholdCount | int | `2` | Success threshold |
| ingress.alb.healthcheck.intervalSeconds | int | `15` | Period seconds |
| ingress.alb.healthcheck.protocol | string | `"HTTP"` | Healthcheck protocol |
| ingress.alb.healthcheck.timeoutSeconds | int | `5` | Timeout seconds |
| ingress.alb.healthcheck.unhealthyThresholdCount | int | `2` | Failure threshold |
| ingress.alb.preStopDelay.delaySeconds | int | `15` | The delay (sleep) to wait for. IMPORTANT: The terminationGracePeriodSeconds must be greater than this. |
| ingress.alb.preStopDelay.enabled | bool | `true` | Enable an additional delay when the container is shutdown of delaySeconds. This allows ALB to fully de-register the pod (allows zero-downtime rollouts) |
| ingress.alb.scheme | string | `"internet-facing"` | Public, private or api-specific alb (internet-facing / internal / api) |
| ingress.alb.targetGroupAttributes | object | `{"deregistration_delay.timeout_seconds":5,"load_balancing.algorithm.type":"least_outstanding_requests"}` | Target group attributes (see: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes) |
| ingress.allowFrontendAccess | bool | `false` | Explicitly set the 'tier: frontend' label on deployments even if ingress is disabled |
| ingress.allowLivenessUrl | bool | `false` | Set to true to allow the liveness URL through the ingress |
| ingress.allowReadinessUrl | bool | `false` | Set to true to allow the readiness URL through the ingress |
| ingress.enabled | bool | `false` | Set to true to enable ingress record generation |
| ingress.extraAnnotations | object | `{}` | Additional Ingress annotations For a full list of possible ingress annotations, please see ref: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md |
| ingress.extraHosts | list | `[]` | List of extra ingress hosts to setup. The CNAMEs for these hosts must already exist, please reach out to the Infrastructure team to create them if needed. |
| ingress.extraIngresses | list | `[]` | Optional: ability to construct multiple ingresses with different settings (names, cache headers, etc) This accepts all the same values as the top-level ingress. It also inherits its default values from the top-level ingress, so all differences must be overridden per-instance. |
| ingress.specificRulesHostsYaml | object | `{}` | Optional ingress Rules Hosts Yaml that doesn't fit standard pattern |
| ingress.specificTlsHostsYaml | object | `{}` | Optional ingress Tls Hosts Yaml that doesn't fit standard pattern |
| ingress.tls | bool | `true` | Enable TLS configuration for the hostname defined at ingress.hostname parameter |
| jobDefaults | object | See below. | Configure default values for all jobs as defined in `$.Values.jobs` |
| jobDefaults.annotations | object | `{}` | Any annotations you wish to add to the Job |
| jobDefaults.argo | object | See below. | ArgoCD sync config |
| jobDefaults.argo.hook | string | `nil` | Phase in which ArgoCD should apply the manifest ref: https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/#usage. |
| jobDefaults.argo.hookDeletePolicy | string | `nil` | When to delete the job resources in an automated fashion ref: https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/#hook-deletion-policies. |
| jobDefaults.argo.syncWave | string | `nil` | Sync Wave in which ArgoCD should apply the manifest. ref: https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/. |
| jobDefaults.args | string | `nil` | The command arguments for the main Job container. |
| jobDefaults.command | string | `nil` | The command the main Job container will run. |
| jobDefaults.enableDoNotDisrupt | bool | `true` | Whether to set the `karpenter.sh/do-not-disrupt`annotation on the Job |
| jobDefaults.env | list | `[]` | Any env entries you want to add. See includeBaseEnv to add all from main container. ref: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/ |
| jobDefaults.envFrom | list | `[]` | Any envFrom entries you want to add. See includeBaseEnv to add all from main container. ref: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/ |
| jobDefaults.extraInitContainers | list | `[]` | A list of initContainers you want to add to the Job. |
| jobDefaults.image | string | Same as `$.Values.image` | The image to use in the main container for the Job. |
| jobDefaults.includeAppSecret | bool | `false` | Whether you want the secrets used by the main app workload to be available to the Job |
| jobDefaults.includeBaseEnv | bool | `false` | Whether you want the environment variables used by the main app workload to be available to the Job |
| jobDefaults.includeBasePodSecurityContext | bool | `false` | Whether you want the securityContext used by the main app workload to be the same in the Job |
| jobDefaults.labels | object | `{}` | Any labels you wish to add to the Job. |
| jobDefaults.name | string | `nil` | REQUIRED FOR ALL JOBS. The name of the job. |
| jobDefaults.podSecurityContext | object | `{}` | Add podSecurityContext config to the Job. |
| jobDefaults.resources | object | `{}` | REQUIRED FOR ALL JOBS. Resource requests/limits. |
| jobDefaults.restartPolicy | string | `"Never"` | Whether the pod should be restarted on failure ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy) |
| jobDefaults.ttlSecondsAfterFinished | int | `60` | If this field is set, ttlSecondsAfterFinished after the Job finishes, it is eligible to be automatically deleted. ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#cronjob-v1beta1-batch |
| jobs | list | `[]` | Define and configure jobs Add a map for each job in this list. Refer to `$.Values.jobDefaults` for a list of supported values (and the defaults that will be applied to all jobs below). |
| jobsOnly | bool | `false` | Only show Jobs and relevant resources (i.e. if set to `true`, hide the main deployment resource) |
| kibana.elasticsearchHosts | string | `""` |  |
| kibana.enabled | bool | `false` |  |
| kubelock | object | `{"enabled":false}` | Configure the use of kubelock ref: https://github.com/mintel/kubelock |
| kubelock.enabled | bool | `false` | Set to true to enable kubelock |
| liveness | object | `{"enabled":true,"startup":{"failureThreshold":60,"periodSeconds":5}}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| liveness.enabled | bool | `true` | Enable liveness probe |
| liveness.startup | object | `{"failureThreshold":60,"periodSeconds":5}` | Configure startup probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes |
| liveness.startup.failureThreshold | int | `60` | Failure threshold for startupProbe |
| liveness.startup.periodSeconds | int | `5` | Perios seconds for startupProbe |
| localstack.enableStartupScripts | bool | `true` |  |
| localstack.enabled | bool | `false` |  |
| localstack.extraEnvVars[0].name | string | `"AWS_DEFAULT_REGION"` |  |
| localstack.extraEnvVars[0].value | string | `"us-east-1"` |  |
| localstack.extraEnvVars[1].name | string | `"AWS_ACCESS_KEY_ID"` |  |
| localstack.extraEnvVars[1].value | string | `"test"` |  |
| localstack.extraEnvVars[2].name | string | `"AWS_SECRET_ACCESS_KEY"` |  |
| localstack.extraEnvVars[2].value | string | `"test"` |  |
| localstack.mountDind.enabled | bool | `true` |  |
| localstack.service.type | string | `"ClusterIP"` |  |
| localstack.startServices | string | `"sns, sqs, s3"` |  |
| mailhog.enabled | bool | `false` |  |
| main | object | `{"env":[]}` | Optional environment variables injected into the 'main' container of the app-deployment |
| mariadb.client.enabled | bool | `true` |  |
| mariadb.client.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.client.resources.requests.cpu | string | `"10m"` |  |
| mariadb.client.resources.requests.memory | string | `"64Mi"` |  |
| mariadb.enabled | bool | `false` |  |
| mariadb.extraUsers | object | `{"enabled":false,"job":{"logLevel":"INFO"},"users":[]}` | set up extra users for a database and table that already exist |
| mariadb.metrics.enabled | bool | `false` |  |
| mariadb.metrics.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.metrics.resources.requests.cpu | string | `"10m"` |  |
| mariadb.metrics.resources.requests.memory | string | `"64Mi"` |  |
| mariadb.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| memcached.enabled | bool | `false` |  |
| memcached.outputSecret | bool | `true` |  |
| metrics | object | `{"additionalMonitors":[],"basicAuth":{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""},"enabled":true}` | Prometheus Exporter / Metrics |
| metrics.basicAuth | object | `{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""}` | Scheme (HTTP ot HTTPS)  scheme: HTTP |
| metrics.enabled | bool | `true` | Enable Prometheus to access aplpication metrics endpoints |
| minReadySeconds | int | `10` | Minimum number of seconds before deployments are ready |
| nameOverride | string | `""` | String to fully override mintel_common.fullname template |
| networkPolicy | object | `{"additionalAllowFroms":[],"enabled":true}` | Define a default NetworkPolicy for allowing apps in the same 'app.kubernetes.io/part-of' group to communicate with eachother. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| nlb.enabled | bool | `false` |  |
| nlb.healthcheck | object | `{"healthyThresholdCount":2,"intervalSeconds":10,"protocol":"TCP","timeoutSeconds":5,"unhealthyThresholdCount":2}` | Configure healthchecks |
| nlb.healthcheck.healthyThresholdCount | int | `2` | Success threshold |
| nlb.healthcheck.intervalSeconds | int | `10` | Period seconds {can only be 10 or 30 seconds) |
| nlb.healthcheck.protocol | string | `"TCP"` | Healthcheck protocol |
| nlb.healthcheck.timeoutSeconds | int | `5` | Timeout seconds |
| nlb.healthcheck.unhealthyThresholdCount | int | `2` | Failure threshold |
| nlb.scheme | string | `"internet-facing"` | Public or private nlb (internet-facing / internal) |
| nlb.targetType | string | `"ip"` | TargetType {instance = nodePort, ip = podIP} |
| oauthProxy | object | `{"allowedGroups":[],"emailDomain":"","enabled":false,"env":[],"image":"quay.io/oauth2-proxy/oauth2-proxy:v7.1.3","ingressHost":"","issuerUrl":"https://oauth.mintel.com","localSecretValues":[],"scope":"openid profile email","secretNameOverride":"","secretRefreshIntervalOverride":"","secretStoreRefOverride":"","secretSuffix":"","skipAuthRegexes":[],"type":"portal","userIdClaim":""}` | Configure oauth-proxy sidecar for main deployment |
| oauthProxy.allowedGroups | list | `[]` | Optional: list of group ids to restrict access to |
| oauthProxy.emailDomain | string | `""` | Optional: email domain to restrict access to |
| oauthProxy.enabled | bool | `false` | Set to true to enable oauth-proxy sidecar |
| oauthProxy.env | list | `[]` | Optional environment variables injected into the container |
| oauthProxy.image | string | `"quay.io/oauth2-proxy/oauth2-proxy:v7.1.3"` | Full image name override |
| oauthProxy.ingressHost | string | `""` | Optional: hostname for proxy redirect url (defaults to service defaultHost) |
| oauthProxy.issuerUrl | string | `"https://oauth.mintel.com"` | Optional: URL of the OIDC issuer |
| oauthProxy.scope | string | `"openid profile email"` | Optional: OAuth scope specification |
| oauthProxy.secretNameOverride | string | `""` | Optional: full name override for oauth secret |
| oauthProxy.secretRefreshIntervalOverride | string | `""` | Optional: ExternalSecret refreshInterval override |
| oauthProxy.secretStoreRefOverride | string | `""` | Optional: full SecretStoreRef override for oauth ExternalSecret |
| oauthProxy.secretSuffix | string | `""` | Optional: oauth secret suffix, eg '-oauth' |
| oauthProxy.skipAuthRegexes | list | `[]` | Optional: list of URL endpoints to bypass oauth-proxy for Health check and readiness urls are skipped automatically |
| oauthProxy.type | string | `"portal"` | Identifies oauth-proxy as auth'ing with a mintel portal instance |
| oauthProxy.userIdClaim | string | `""` | Optional: Claim contains the user ID |
| opensearch | object | `{"awsEsProxy":{"enabled":false,"ingress":{"alb":{"backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"path":"/_cluster/health","protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing","targetGroupAttributes":{"deregistration_delay.timeout_seconds":5,"load_balancing.algorithm.type":"least_outstanding_requests"}},"enabled":false,"extraAnnotations":{},"path":"/_dashboards"},"port":9200,"resources":{"limits":{"memory":"128Mi"},"requests":{"cpu":"10m","memory":"64Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}},"enabled":false,"outputSecret":true,"secretRefreshIntervalOverride":"","secretStoreRefOverride":""}` | Configures AWS Opensearch deployment/connections |
| opensearch.awsEsProxy | object | `{"enabled":false,"ingress":{"alb":{"backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"path":"/_cluster/health","protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing","targetGroupAttributes":{"deregistration_delay.timeout_seconds":5,"load_balancing.algorithm.type":"least_outstanding_requests"}},"enabled":false,"extraAnnotations":{},"path":"/_dashboards"},"port":9200,"resources":{"limits":{"memory":"128Mi"},"requests":{"cpu":"10m","memory":"64Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}}` | Configures aws-es-proxy to enable external access to opensearch |
| opensearch.awsEsProxy.enabled | bool | `false` | Set to true to add an aws-es-proxy deployment in front of opensearch |
| opensearch.awsEsProxy.ingress.alb.backendProtocol | string | `"HTTP"` | Application Version (HTTP / HTTPS) |
| opensearch.awsEsProxy.ingress.alb.backendProtocolVersion | string | `"HTTP1"` | Application Protocol Version (HTTP1 / HTTP2 / GRPC) |
| opensearch.awsEsProxy.ingress.alb.healthcheck.healthyThresholdCount | int | `2` | Success threshold |
| opensearch.awsEsProxy.ingress.alb.healthcheck.intervalSeconds | int | `15` | Period seconds |
| opensearch.awsEsProxy.ingress.alb.healthcheck.path | string | `"/_cluster/health"` | Healthcheck Request path |
| opensearch.awsEsProxy.ingress.alb.healthcheck.protocol | string | `"HTTP"` | Healthcheck protocol |
| opensearch.awsEsProxy.ingress.alb.healthcheck.timeoutSeconds | int | `5` | Timeout seconds |
| opensearch.awsEsProxy.ingress.alb.healthcheck.unhealthyThresholdCount | int | `2` | Failure threshold |
| opensearch.awsEsProxy.ingress.alb.preStopDelay.delaySeconds | int | `15` | The delay (sleep) to wait for. IMPORTANT: The terminationGracePeriodSeconds must be greater than this. |
| opensearch.awsEsProxy.ingress.alb.preStopDelay.enabled | bool | `true` | Enable an additional delay when the container is shutdown of delaySeconds. This allows ALB to fully de-register the pod (allows zero-downtime rollouts) |
| opensearch.awsEsProxy.ingress.alb.scheme | string | `"internet-facing"` | Public or private alb (internet-facing / internal) |
| opensearch.awsEsProxy.ingress.alb.targetGroupAttributes | object | `{"deregistration_delay.timeout_seconds":5,"load_balancing.algorithm.type":"least_outstanding_requests"}` | Target group attributes (see: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes) |
| opensearch.awsEsProxy.ingress.path | string | `"/_dashboards"` | Path for the Ingress |
| opensearch.awsEsProxy.port | int | `9200` | Port for aws-es-proxy to listen on |
| opensearch.awsEsProxy.resources | object | `{"limits":{"memory":"128Mi"},"requests":{"cpu":"10m","memory":"64Mi"}}` | Container resource requests and limits for aws-es-proxy sidecar ref: http://kubernetes.io/docs/user-guide/compute-resources |
| opensearch.awsEsProxy.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Ingress for aws-es-proxy |
| opensearch.enabled | bool | `false` | Set to true if deployment makes use of AWS opensearch |
| opensearch.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| opensearch.secretRefreshIntervalOverride | string | `""` | Optional: ExternalSecret refreshInterval override |
| opensearch.secretStoreRefOverride | string | `""` | Optional: override the SecretStoreRef of the ExternalSecret |
| otel | object | `{"exporter":{"endpoint":"http://grafana-agent.monitoring.svc.cluster.local:4317"},"extraEnv":[],"java":{"enabled":false,"extraEnv":[]},"python":{"enabled":false,"excludedUrls":"/health[zy]?,/liveness,/ready[z]?,/readiness,/external-health-check,/metrics,/favicon.ico,/static.*","extraEnv":[]},"sampler":{"arg":"","type":"parentbased_always_on"}}` | Enabled opentelemetry-operator Instrumentation |
| otel.exporter | object | `{"endpoint":"http://grafana-agent.monitoring.svc.cluster.local:4317"}` | The endpoint to send traces/spans to. |
| otel.extraEnv | list | `[]` | Additional otel (generic) vars to add to the pod |
| otel.java.enabled | bool | `false` | Enable/disable injecting Java otel environment vars |
| otel.java.extraEnv | list | `[]` | Additional Java specific vars to add to the pod |
| otel.python.enabled | bool | `false` | Enable/disable injecting Python otel environment vars |
| otel.python.excludedUrls | string | `"/health[zy]?,/liveness,/ready[z]?,/readiness,/external-health-check,/metrics,/favicon.ico,/static.*"` | Urls to exclude |
| otel.python.extraEnv | list | `[]` | Additional Python specific vars to add to the pod |
| otel.sampler | object | `{"arg":"","type":"parentbased_always_on"}` | The sampler configuration ref: https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/sdk.md#sampling |
| otel.sampler.arg | string | `""` | Configures OTEL_TRACES_SAMPLER_ARG |
| otel.sampler.type | string | `"parentbased_always_on"` | Configures OTEL_TRACES_SAMPLER |
| persistentVolumes | string | `nil` | A list of persistent volume claims to be added to the pod |
| podAnnotations | object | `{}` | Additional annotations to apply to the pod |
| podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%","unhealthyPodEvictionPolicy":"AlwaysAllow"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `"AlwaysAllow"` | Controls how Pod Disruption Budgets apply to pods that are unhealthy.    The default is to allow them to be terminated. |
| podSecurityContext | object | `{"runAsNonRoot":true,"runAsUser":1000}` | Pod Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| port | int | `8000` | Set port to null to skip adding container Ports |
| postgresql.client.enabled | bool | `true` |  |
| postgresql.client.resources.limits.memory | string | `"128Mi"` |  |
| postgresql.client.resources.requests.cpu | string | `"10m"` |  |
| postgresql.client.resources.requests.memory | string | `"64Mi"` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.extraUsers.enabled | bool | `false` |  |
| postgresql.extraUsers.job.logLevel | string | `"INFO"` |  |
| postgresql.extraUsers.users | list | `[]` |  |
| postgresql.image.tag | string | `"13.5.0-debian-10-r52"` |  |
| postgresql.metrics.enabled | bool | `false` |  |
| postgresql.metrics.resources.limits.memory | string | `"128Mi"` |  |
| postgresql.metrics.resources.requests.cpu | string | `"10m"` |  |
| postgresql.metrics.resources.requests.memory | string | `"64M"` |  |
| postgresql.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| postgresql.postgresqlDatabase | string | `"postgres"` |  |
| priorityClassName | string | `""` | Optional name of PriorityClass to run pods with |
| readiness | object | `{"enabled":true}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| redis.enabled | bool | `false` |  |
| redis.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| redis.replica.replicaCount | int | `0` |  |
| redis.tls.enabled | bool | `false` |  |
| replicas | int | `2` | Desired number of replicas for main deployment |
| resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| resources.limits | object | `{}` | The resource limits for the container |
| resources.requests | object | `{}` | The requested resources for the container |
| s3.enabled | bool | `false` |  |
| s3.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":1000}` | Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| service | object | `{"annotations":{},"enabled":true,"labels":{},"type":"ClusterIP"}` | Kubernetes svc configutarion |
| service.annotations | object | `{}` | Annotations to add to service |
| service.enabled | bool | `true` | Whether to create Service resource or not |
| service.labels | object | `{}` | Provide any additional labels which may be required. |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"clusterRoles":[],"create":true,"irsa":{"enabled":false,"nameOverride":""},"name":"","roles":[]}` | ServiceAccount parameters ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| serviceAccount.annotations | object | `{}` | Additional Service Account annotations |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automount the service account token or not |
| serviceAccount.clusterRoles | list | `[]` | Define list of ClusterRole's to create and bind to the service account ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/ |
| serviceAccount.create | bool | `true` | Determine whether a Service Account should be created or it should reuse a exiting one. |
| serviceAccount.irsa | object | `{"enabled":false,"nameOverride":""}` | Configures IRSA for the Service Account |
| serviceAccount.irsa.enabled | bool | `false` | Determines whether service account is IRSA enabled |
| serviceAccount.irsa.nameOverride | string | `""` | Override for last component of role-arn, ie: accountid-clusterName-namespace-{nameOverride} |
| serviceAccount.name | string | `""` | ServiceAccount to use. A name is generated using the mintel_common.fullname template if it is not set |
| serviceAccount.roles | list | `[]` | Define list of Role's to create and bind to the service account ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/ |
| singleReplicaOnly | bool | `false` | Explicitly stating that a single replica is required Should only be used if the image truly can't be run multiple times usually involving third party apps or prometheus exporters, etc |
| sqs.enabled | bool | `false` |  |
| sqs.outputSecret | bool | `true` | set outputSecret to true to allow TF Cloud chart create ExternalSecrets |
| statefulset | bool | `false` | Defines whether the deployment should be a statefulset or not |
| strategy | object | `{"maxSurge":"15%","maxUnavailable":"10%","type":"RollingUpdate"}` | Defines deployment update strategy |
| strategy.maxSurge | string | `"15%"` | Optional argument to define maximum number of pods allowed over defined replicas |
| strategy.maxUnavailable | string | `"10%"` | Optional argument to define maximum number of pods that can be unavailable during update |
| strategy.type | string | `"RollingUpdate"` | Type of strategy to use (Recreate or RollingUpdate) |
| terminationGracePeriodSeconds | int | `30` | Configure terminationGracePeriodSeconds ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/ |
| topologySpreadConstraints.enabled | bool | `true` |  |
| topologySpreadConstraints.node.enabled | string | `nil` | Set this to true/false to override the default behaviour (enabled for prod only) |
| topologySpreadConstraints.node.matchlabelkeys.enabled | bool | `false` |  |
| topologySpreadConstraints.node.maxSkew | int | `1` |  |
| topologySpreadConstraints.specificYaml | string | `nil` | Specify custom topologySpreadConstraints yaml |
| topologySpreadConstraints.zone.enabled | bool | `true` |  |
| topologySpreadConstraints.zone.matchlabelkeys.enabled | bool | `false` |  |
| topologySpreadConstraints.zone.maxSkew | int | `1` |  |
| useHostNetwork | bool | `false` | If true, use the host network for the main deployment. |
| verticalPodAutoscaler | object | `{"autoscalingEnabled":false,"containerPolicies":null,"enabled":true,"evictionRequirements":null,"instances":{},"minReplicas":1}` | Configuration for creating a VerticalPodAutoscaler for this app. Currently only supports recommendations-only mode. |
| verticalPodAutoscaler.autoscalingEnabled | bool | `false` | Set to true to automatically apply the resource recommendations of VerticalPodAutoscaler. |
| verticalPodAutoscaler.containerPolicies | string | `nil` | Set policies for containers within each pod. |
| verticalPodAutoscaler.enabled | bool | `true` | Set to true to create a VerticalPodAutoscaler. |
| verticalPodAutoscaler.evictionRequirements | string | `nil` | Set requirements for VPA to evict pods, if autoscaling is enabled. |
| verticalPodAutoscaler.instances | object | `{}` | The settings above are defaults for all VPAs. You can override the settings for specific VPAs here. |
| verticalPodAutoscaler.minReplicas | int | `1` | The minimum number of replicas a workload needs to have for VPA to consider evicting pods. |
| volumeMounts | list | `[]` | A list of volume mounts to be added to the pod |
| volumes | string | `nil` | A list of volumes to be added to the pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
