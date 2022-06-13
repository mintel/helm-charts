# standard-application-stack

![Version: 3.29.0](https://img.shields.io/badge/Version-3.29.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| args | list | `[]` | Optional arguments to the container |
| celery | object | `{"args":["celery"],"enabled":false,"liveness":{"enabled":false},"metrics":{"enabled":true},"podDisruptionBudget":{"enabled":true,"minAvailable":"50%"},"readiness":{"enabled":false},"replicas":2,"resources":{"limits":{},"requests":{}},"startup":{"failureThreshold":60,"methodOverride":{},"periodSeconds":5}}` | Configure celery deployment Defaults to same image as main deployment but with the "celery" argument |
| celery.args | list | `["celery"]` | Arguments to the celery container |
| celery.enabled | bool | `false` | Set to true to enable a celery deployment |
| celery.liveness | object | `{"enabled":false}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.liveness.enabled | bool | `false` | Enable liveness probe |
| celery.metrics | object | `{"enabled":true}` | Prometheus Exporter / Metrics |
| celery.metrics.enabled | bool | `true` | Enable Prometheus to access application metrics endpoints |
| celery.podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| celery.readiness | object | `{"enabled":false}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.readiness.enabled | bool | `false` | Enable readiness probe |
| celery.replicas | int | `2` | Desired number of replicas for celery deployment |
| celery.resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
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
| celeryBeat.resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| celeryBeat.resources.limits | object | `{}` | The resource limits for the container |
| celeryBeat.resources.requests | object | `{}` | The requested resources for the container |
| command | list | `["/app/docker-entrypoint.sh"]` | Optional command to the container |
| configMaps | list | `[]` | A list of configuration maps for this application |
| cronjobs | object | `{"defaults":{"concurrencyPolicy":"Forbid","restartPolicy":"Never","suspend":false},"jobs":[]}` | Define and Configure CronJob's Defaults to same image as main deployment but with defined arguments |
| cronjobs.defaults | object | `{"concurrencyPolicy":"Forbid","restartPolicy":"Never","suspend":false}` | Defaults for all CronJob's |
| cronjobs.defaults.concurrencyPolicy | string | `"Forbid"` | Tells controller how to handle concurrent executions of a CronJob ref: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/#CronJobSpec |
| cronjobs.defaults.restartPolicy | string | `"Never"` | Configure CronJob pod restart Policy ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy |
| cronjobs.defaults.suspend | bool | `false` | Tells controller to suspend future executions ref: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/#CronJobSpec |
| cronjobs.jobs | list | `[]` | List of Cronjob configurations to be defined |
| cronjobsOnly | bool | `false` | Only show cronjobs and relevant resources (i.e. if set to `true`, hide the main deployment resource) |
| dynamodb.enabled | bool | `false` |  |
| elasticsearch.enabled | bool | `false` |  |
| elasticsearch.secretRefreshIntervalOverride | string | `""` | Optional: ExternalSecret refreshInterval override |
| elasticsearch.secretStoreRefOverride | string | `""` | Optional: override the SecretStoreRef of the ExternalSecret |
| env | list | `[]` | Optional environment variables injected into the container |
| envFrom | list | `[]` | Optional environment variables injected into the container using envFrom (secrets/configmaps) |
| externalSecret | object | `{"enabled":true}` | Define ExternalSecret from AWS ref: https://github.com/external-secrets/kubernetes-external-secrets |
| extraContainers | list | `[]` | Enable extraContainers (oauth2-proxy is a common example) |
| extraInitContainers | list | `[]` | Enable extra init-containers |
| extraPorts | list | `[]` | Optional list of extra container ports to configure |
| extraSecrets | list | `[]` |  |
| filebeatSidecar.enabled | bool | `false` |  |
| filebeatSidecar.metrics.enabled | bool | `true` |  |
| filebeatSidecar.metrics.resources.limits.cpu | string | `"200m"` |  |
| filebeatSidecar.metrics.resources.limits.memory | string | `"200Mi"` |  |
| filebeatSidecar.metrics.resources.requests.cpu | string | `"100m"` |  |
| filebeatSidecar.metrics.resources.requests.memory | string | `"100Mi"` |  |
| filebeatSidecar.resources.limits.cpu | string | `"200m"` |  |
| filebeatSidecar.resources.limits.memory | string | `"200Mi"` |  |
| filebeatSidecar.resources.requests.cpu | string | `"100m"` |  |
| filebeatSidecar.resources.requests.memory | string | `"100Mi"` |  |
| gitSyncSidecar | object | `{"branch":"main","enabled":false,"resources":{"limits":{"cpu":"200m","memory":"200Mi"},"requests":{"cpu":"50m","memory":"50Mi"}},"root":"/data/git-sync"}` | Helper to sync a local directory with Git ref: https://github.com/kubernetes/git-sync |
| gitSyncSidecar.branch | string | `"main"` | The git branch to check out |
| global | object | `{"additionalLabels":{},"cloudProvider":{"accountId":""},"clusterDomain":"127.0.0.1.nip.io","clusterEnv":"local","clusterName":"","ingressTLSSecrets":{},"name":"example-app","owner":"","partOf":"","runtimeEnvironment":"kubernetes","terraform":{"externalSecrets":false,"irsa":false}}` | Global variables for us in all charts and sub charts |
| global.additionalLabels | object | `{}` | Additional labels to apply to all resources |
| global.cloudProvider | object | `{"accountId":""}` | Global variables relating to cloud provider |
| global.cloudProvider.accountId | string | `""` | AWS ACcount Id |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Kubernetes cluster domain |
| global.clusterEnv | string | `"local"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `""` | Kubernetes cluster name |
| global.ingressTLSSecrets | object | `{}` | Global dictionary of TLS secrets |
| global.name | string | `"example-app"` | Name of the application |
| global.owner | string | `""` | Team which "owns" the application |
| global.partOf | string | `""` | Top level application each deployment is a part of |
| global.runtimeEnvironment | string | `"kubernetes"` | Global variable definint RUNTIME_ENVIRONMENT |
| hybridCloud | object | `{"consulNamespace":"hybrid-consul","enabled":false,"metrics":{"enabled":true},"proxyPort":20000,"upstreamServices":[]}` | Configure Consul annotations to the main deployment for hybrid cloud integration |
| hybridCloud.consulNamespace | string | `"hybrid-consul"` | Define namespace that Consul is runnign in |
| hybridCloud.enabled | bool | `false` | Set to true to integrate with hybrid cloud (Consul) |
| hybridCloud.metrics | object | `{"enabled":true}` | Configure metrics scraping of Consul Proxy |
| hybridCloud.metrics.enabled | bool | `true` | Enable Prometheus to scrape consul proxy metrics |
| hybridCloud.proxyPort | int | `20000` | Set port for Envoy proxy public listener (the port consul talks back to envoy on) |
| hybridCloud.upstreamServices | list | `[]` | Defines list of upstream services to connect to  upstreamServices:    - 'service1:1234'    - 'service2:2345' |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"","repository":"test","tag":"auto-replaced"}` | Docker image values |
| image.pullPolicy | string | `"IfNotPresent"` | Optional ImagePullPolicy ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images |
| image.registry | string | `""` | Docker registry used to pull application image |
| image.repository | string | `"test"` | Docker repository |
| image.tag | string | `"auto-replaced"` | Container image tag |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"alb":{"backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","deregistrationDelay":{"timeoutSeconds":5},"enabled":false,"healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing"},"allowLivenessUrl":false,"allowReadinessUrl":false,"blackbox":{"enabled":true,"probePath":"/external-health-check"},"enabled":false,"extraAnnotations":{},"extraHosts":[],"specificRulesHostsYaml":{},"specificTlsHostsYaml":{},"tls":true}` | Configure the ingress resource that allows you to access the application from public-internet ref: http://kubernetes.io/docs/user-guide/ingress/ |
| ingress.alb.backendProtocol | string | `"HTTP"` | Application Version (HTTP / HTTPS) |
| ingress.alb.backendProtocolVersion | string | `"HTTP1"` | Application Protocol Version (HTTP1 / HTTP2 / GRPC) |
| ingress.alb.healthcheck.healthyThresholdCount | int | `2` | Success threshold |
| ingress.alb.healthcheck.intervalSeconds | int | `15` | Period seconds |
| ingress.alb.healthcheck.protocol | string | `"HTTP"` | Healthcheck protocol |
| ingress.alb.healthcheck.timeoutSeconds | int | `5` | Timeout seconds |
| ingress.alb.healthcheck.unhealthyThresholdCount | int | `2` | Failure threshold |
| ingress.alb.preStopDelay.delaySeconds | int | `15` | The delay (sleep) to wait for. IMPORTANT: The terminationGracePeriodSeconds must be greater than this. |
| ingress.alb.preStopDelay.enabled | bool | `true` | Enable an additional delay when the container is shutdown of delaySeconds. This allows ALB to fully de-register the pod (allows zero-downtime rollouts) |
| ingress.alb.scheme | string | `"internet-facing"` | Public or private alb (internet-facing / internal) |
| ingress.allowLivenessUrl | bool | `false` | Set to true to allow the liveness URL through the ingress |
| ingress.allowReadinessUrl | bool | `false` | Set to true to allow the readiness URL through the ingress |
| ingress.blackbox | object | `{"enabled":true,"probePath":"/external-health-check"}` | Configures annotations defining blackbox endpoints |
| ingress.blackbox.enabled | bool | `true` | Set to true to tell blackboxes to hit endpoint |
| ingress.blackbox.probePath | string | `"/external-health-check"` | Endpoint for blackboxes to hit |
| ingress.enabled | bool | `false` | Set to true to enable ingress record generation |
| ingress.extraAnnotations | object | `{}` | Additional Ingress annotations For a full list of possible ingress annotations, please see ref: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md |
| ingress.extraHosts | list | `[]` | List of extra ingress hosts to setup |
| ingress.specificRulesHostsYaml | object | `{}` | Optional ingress Rules Hosts Yaml that doesn't fit standard pattern |
| ingress.specificTlsHostsYaml | object | `{}` | Optional ingress Tls Hosts Yaml that doesn't fit standard pattern |
| ingress.tls | bool | `true` | Enable TLS configuration for the hostname defined at ingress.hostname parameter |
| k8snotify | object | `{"dashboardUrl":"","enabled":false,"receiver":"flowdock","team":""}` | Configure the use of k8snotify ref: https://github.com/mintel/k8s-notify |
| k8snotify.dashboardUrl | string | `""` | Defines dashboard URL to be set for k8s-notify.monitoring-url annotation |
| k8snotify.enabled | bool | `false` | Set to true to enable k8snotify notifications |
| k8snotify.receiver | string | `"flowdock"` | Defines the receiver of the notifications (flowdock) |
| k8snotify.team | string | `""` | Defines team (flow) notifications are to be directed at |
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
| mariadb.client.enabled | bool | `true` |  |
| mariadb.client.resources.limits.cpu | string | `"300m"` |  |
| mariadb.client.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.client.resources.requests.cpu | string | `"100m"` |  |
| mariadb.client.resources.requests.memory | string | `"64Mi"` |  |
| mariadb.enabled | bool | `false` |  |
| mariadb.metrics.enabled | bool | `false` |  |
| mariadb.metrics.resources.limits.cpu | string | `"300m"` |  |
| mariadb.metrics.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.metrics.resources.requests.cpu | string | `"100m"` |  |
| mariadb.metrics.resources.requests.memory | string | `"64Mi"` |  |
| metrics | object | `{"additionalMonitors":[],"basicAuth":{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""},"enabled":true}` | Prometheus Exporter / Metrics |
| metrics.basicAuth | object | `{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""}` | Scheme (HTTP ot HTTPS)  scheme: HTTP |
| metrics.enabled | bool | `true` | Enable Prometheus to access aplpication metrics endpoints |
| minReadySeconds | int | `10` | Minimum number of seconds before deployments are ready |
| nameOverride | string | `""` | String to fully override mintel_common.fullname template |
| networkPolicy | object | `{"additionalAllowFroms":[],"enabled":true}` | Define a default NetworkPolicy for allowing apps in the same 'app.kubernetes.io/part-of' group to communicate with eachother. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
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
| opensearch | object | `{"awsEsProxy":{"enabled":false,"port":9200,"resources":{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}},"enabled":false,"secretRefreshIntervalOverride":"","secretStoreRefOverride":""}` | Configures AWS Opensearch deployment/connections |
| opensearch.awsEsProxy | object | `{"enabled":false,"port":9200,"resources":{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}}` | Configures aws-es-proxy to enable external access to opensearch |
| opensearch.awsEsProxy.enabled | bool | `false` | Set to true to add an aws-es-proxy deployment in front of opensearch |
| opensearch.awsEsProxy.port | int | `9200` | Port for aws-es-proxy to listen on |
| opensearch.awsEsProxy.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}` | Container resource requests and limits for aws-es-proxy sidecar ref: http://kubernetes.io/docs/user-guide/compute-resources |
| opensearch.enabled | bool | `false` | Set to true if deployment makes use of AWS opensearch |
| opensearch.secretRefreshIntervalOverride | string | `""` | Optional: ExternalSecret refreshInterval override |
| opensearch.secretStoreRefOverride | string | `""` | Optional: override the SecretStoreRef of the ExternalSecret |
| persistentVolumes | string | `nil` | A list of persistent volume claims to be added to the pod |
| podAnnotations | object | `{}` | Additional annotations to apply to the pod |
| podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| podSecurityContext | object | `{"runAsUser":1000}` | Pod Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| port | int | `8000` | Set port to null to skip adding container Ports |
| postgresql.client.enabled | bool | `true` |  |
| postgresql.client.resources.limits.cpu | string | `"300m"` |  |
| postgresql.client.resources.limits.memory | string | `"128Mi"` |  |
| postgresql.client.resources.requests.cpu | string | `"100m"` |  |
| postgresql.client.resources.requests.memory | string | `"64Mi"` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.image.tag | string | `"13.5.0-debian-10-r52"` |  |
| postgresql.metrics.enabled | bool | `false` |  |
| postgresql.metrics.resources.limits.cpu | string | `"300m"` |  |
| postgresql.metrics.resources.limits.memory | string | `"128Mi"` |  |
| postgresql.metrics.resources.requests.cpu | string | `"100m"` |  |
| postgresql.metrics.resources.requests.memory | string | `"64Mi"` |  |
| postgresql.postgresqlDatabase | string | `"postgres"` |  |
| priorityClassName | string | `""` | Optional name of PriorityClass to run pods with |
| readiness | object | `{"enabled":true}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| redis.enabled | bool | `false` |  |
| redis.replica.replicaCount | int | `0` |  |
| redis.tls.enabled | bool | `false` |  |
| replicas | int | `2` | Desired number of replicas for main deployment |
| resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| resources.limits | object | `{}` | The resource limits for the container |
| resources.requests | object | `{}` | The requested resources for the container |
| s3.enabled | bool | `false` |  |
| securityContext | object | `{}` | Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
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
| statefulset | bool | `false` | Defines whether the deployment should be a statefulset or not |
| strategy | object | `{"maxSurge":"15%","maxUnavailable":"10%","type":"RollingUpdate"}` | Defines deployment update strategy |
| strategy.maxSurge | string | `"15%"` | Optional argument to define maximum number of pods allowed over defined replicas |
| strategy.maxUnavailable | string | `"10%"` | Optional argument to define maximum number of pods that can be unavailable during update |
| strategy.type | string | `"RollingUpdate"` | Type of strategy to use (Recreate or RollingUpdate) |
| terminationGracePeriodSeconds | int | `30` | Configure terminationGracePeriodSeconds ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/ |
| topologySpreadConstraints.enabled | bool | `true` |  |
| topologySpreadConstraints.node.enabled | string | `nil` | Set this to true/false to override the default behaviour (enabled for prod only) |
| topologySpreadConstraints.node.maxSkew | int | `1` |  |
| topologySpreadConstraints.specificYaml | string | `nil` | Specify custom topologySpreadConstraints yaml |
| topologySpreadConstraints.zone.enabled | bool | `true` |  |
| topologySpreadConstraints.zone.maxSkew | int | `1` |  |
| volumeMounts | list | `[]` | A list of volume mounts to be added to the pod |
| volumes | string | `nil` | A list of volumes to be added to the pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
