# standard-application-stack

![Version: 0.1.2-rc8](https://img.shields.io/badge/Version-0.1.2--rc8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A generic chart to support most common application requirements

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | 9.5.1 |
| https://charts.bitnami.com/bitnami | redis | 15.4.0 |
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
| args | object | `{}` | Optional arguments to the container |
| celery | object | `{"args":{"celery":null},"enabled":false,"liveness":{"enabled":false},"metrics":{"enabled":true},"podDisruptionBudget":{"enabled":true,"minAvailable":"50%"},"readiness":{"enabled":false},"replicas":2,"resources":{"limits":{},"requests":{}}}` | Configure celery deployment Defaults to same image as main deployment but with the "celery" argument |
| celery.args | object | `{"celery":null}` | Full image name override (registry/repository:tag)  image: "" -- Optional command to the celery container  command: [] -- Arguments to the celery container |
| celery.enabled | bool | `false` | Set to true to enable a celery deployment |
| celery.liveness | object | `{"enabled":false}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.liveness.enabled | bool | `false` | Enable liveness probe |
| celery.metrics | object | `{"enabled":true}` | Prometheus Exporter / Metrics |
| celery.metrics.enabled | bool | `true` | Enable Prometheus to access aplpication metrics endpoints |
| celery.podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| celery.readiness | object | `{"enabled":false}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celery.readiness.enabled | bool | `false` | Enable readiness probe |
| celery.replicas | int | `2` | Desired number of replicas for celery deployment |
| celery.resources | object | `{"limits":{},"requests":{}}` | Optional environment variables injected into the container  env: [] -- Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| celery.resources.limits | object | `{}` | The resource limits for the container |
| celeryBeat | object | `{"args":{"celerybeat":null},"enabled":false,"liveness":{"enabled":false},"readiness":{"enabled":false},"resources":{"limits":{},"requests":{}}}` | Configure celerybeat deployment Defaults to same image as main deployment but with the "celerybeat" argument |
| celeryBeat.args | object | `{"celerybeat":null}` | Full image name override (registry/repository:tag)  image: "" -- Optional command to the celery container  command: [] |
| celeryBeat.enabled | bool | `false` | Set to true to enable a celerybeat deployment |
| celeryBeat.liveness | object | `{"enabled":false}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celeryBeat.liveness.enabled | bool | `false` | Enable liveness probe |
| celeryBeat.readiness | object | `{"enabled":false}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| celeryBeat.readiness.enabled | bool | `false` | Enable readiness probe |
| celeryBeat.resources | object | `{"limits":{},"requests":{}}` | Optional environment variables injected into the container  env: [] -- Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| celeryBeat.resources.limits | object | `{}` | The resource limits for the container |
| command | list | `["/app/docker-entrypoint.sh"]` | Optional command to the container |
| configmaps | list | `[]` | A list of configuration maps for this application |
| elasticsearch.enabled | bool | `false` |  |
| env | list | `[]` | Optional environment variables injected into the container |
| envFrom | list | `[]` | Optional environment variables injected into the container using envFrom (secrets/configmaps) |
| externalSecret | object | `{"enabled":true}` | Define ExternalSecret from AWS ref: https://github.com/external-secrets/kubernetes-external-secrets |
| extraContainers | list | `[]` | Enable extraContainers (oauth2-proxy is a common example) |
| extraInitContainers | list | `[]` | Enable extra init-containers |
| extraPorts | list | `[]` | Optional list of extra container ports to configure |
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
| global | object | `{"additionalLabels":{},"cloudProvider":{"accountId":""},"clusterDomain":"127.0.0.1.nip.io","clusterEnv":"local","clusterName":"","owner":"","partOf":"","runtimeEnvironment":"kubernetes"}` | Global variables for us in all charts and sub charts |
| global.additionalLabels | object | `{}` | Additional labels to apply to all resources |
| global.cloudProvider | object | `{"accountId":""}` | Global variables relating to cloud provider |
| global.cloudProvider.accountId | string | `""` | AWS ACcount Id |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Kubernetes cluster domain |
| global.clusterEnv | string | `"local"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `""` | Kubernetes cluster name |
| global.owner | string | `""` | Team which "owns" the application |
| global.partOf | string | `""` | Top level application each deployment is a part of |
| global.runtimeEnvironment | string | `"kubernetes"` | Global variable definint RUNTIME_ENVIRONMENT |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"","repository":"test","tag":"auto-replaced"}` | Docker image values |
| image.pullPolicy | string | `"IfNotPresent"` | Optional ImagePullPolicy ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images |
| image.registry | string | `""` | Docker registry used to pull application image |
| image.repository | string | `"test"` | Docker repository |
| image.tag | string | `"auto-replaced"` | Container image tag |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"tls":true}` | Configure the ingress resource that allows you to access the application from public-internet ref: http://kubernetes.io/docs/user-guide/ingress/ |
| ingress.annotations | object | `{}` | Ingress annotations For a full list of possible ingress annotations, please see ref: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md |
| ingress.className | string | `""` | Define the type of ingress |
| ingress.enabled | bool | `false` | Set to true to enable ingress record generation |
| ingress.tls | bool | `true` | Enable TLS configuration for the hostname defined at ingress.hostname parameter |
| k8snotify | object | `{"enabled":false,"receiver":"flowdock","team":""}` | Configure the use of k8snotify ref: https://github.com/mintel/k8s-notify |
| k8snotify.enabled | bool | `false` | Set to true to enable k8snotify notifications |
| k8snotify.receiver | string | `"flowdock"` | Defines the receiver of the notifications (flowdock) |
| k8snotify.team | string | `""` | Defines team (flow) notifications are to be directed at |
| kibana.elasticsearchHosts | string | `""` |  |
| kibana.enabled | bool | `false` |  |
| liveness | object | `{"enabled":true,"startup":{"failureThreshold":60,"periodSeconds":5}}` | Configure extra options for liveness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| liveness.enabled | bool | `true` | Enable liveness probe |
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
| localstack.startServices | string | `"sns, sqs, s3"` |  |
| mailhog.enabled | bool | `false` |  |
| mariadb.client.enabled | bool | `true` |  |
| mariadb.client.resources.limits.cpu | string | `"300m"` |  |
| mariadb.client.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.client.resources.requests.cpu | string | `"100m"` |  |
| mariadb.client.resources.requests.memory | string | `"64Mi"` |  |
| mariadb.enabled | bool | `false` |  |
| mariadb.metrics.enabled | bool | `true` |  |
| mariadb.metrics.resources.limits.cpu | string | `"300m"` |  |
| mariadb.metrics.resources.limits.memory | string | `"128Mi"` |  |
| mariadb.metrics.resources.requests.cpu | string | `"100m"` |  |
| mariadb.metrics.resources.requests.memory | string | `"64Mi"` |  |
| metrics | object | `{"enabled":true}` | Prometheus Exporter / Metrics |
| metrics.enabled | bool | `true` | Enable Prometheus to access aplpication metrics endpoints |
| minReadySeconds | int | `10` | Minimum number of seconds before deployments are ready |
| nameOverride | string | `""` | String to fully override mintel_common.fullname template |
| networkPolicy | object | `{"enabled":true}` | Define a default NetworkPolicy for allowing apps in the same 'app.kubernetes.io/part-of' group to communicate with eachother. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| opensearch | object | `{"awsEsProxy":{"enabled":false,"port":9200,"resources":{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}},"enabled":false}` | Configures AWS Opensearch deployment/connections |
| opensearch.awsEsProxy | object | `{"enabled":false,"port":9200,"resources":{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}}` | Configures aws-es-proxy to enable external access to opensearch |
| opensearch.awsEsProxy.enabled | bool | `false` | Set to true to add an aws-es-proxy deployment in front of opensearch |
| opensearch.awsEsProxy.port | int | `9200` | Port for aws-es-proxy to listen on |
| opensearch.awsEsProxy.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}` | Container resource requests and limits for aws-es-proxy sidecar ref: http://kubernetes.io/docs/user-guide/compute-resources |
| opensearch.enabled | bool | `false` | Set to true if deployment makes use of AWS opensearch |
| podAnnotations | object | `{}` | Additional annotations to apply to the pod |
| podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| podSecurityContext | object | `{"runAsUser":1000}` | Pod Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| port | int | `8000` | Main container port for the application |
| priorityClassName | string | `""` | Optional name of PriorityClass to run pods with |
| readiness | object | `{"enabled":true}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| redis.enabled | bool | `false` |  |
| redis.replica.replicaCount | int | `0` |  |
| redis.tls.enabled | bool | `false` |  |
| replicas | int | `2` | Desired number of replicas for main deployment |
| resources | object | `{"limits":{},"requests":{}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| resources.limits | object | `{}` | The resource limits for the container |
| securityContext | object | `{}` | Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| service | object | `{"annotations":{},"enabled":true,"labels":{},"type":"ClusterIP"}` | Kubernetes svc configutarion |
| service.annotations | object | `{}` | Annotations to add to service |
| service.enabled | bool | `true` | Whether to create Service resource or not |
| service.labels | object | `{}` | Provide any additional labels which may be required. |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"create":true,"irsa":{"enabled":false,"nameOverride":""},"name":""}` | ServiceAccount parameters ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| serviceAccount.annotations | object | `{}` | Additional Service Account annotations |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automount the service account token or not |
| serviceAccount.create | bool | `true` | Determine whether a Service Account should be created or it should reuse a exiting one. |
| serviceAccount.irsa | object | `{"enabled":false,"nameOverride":""}` | Configures IRSA for the Service Account |
| serviceAccount.irsa.enabled | bool | `false` | Determines whether servier account is IRSA enabled |
| serviceAccount.irsa.nameOverride | string | `""` | Override for last component of role-arn, ie: accountid-clusterName-namespace-{nameOverride} |
| serviceAccount.name | string | `""` | ServiceAccount to use. A name is generated using the mintel_common.fullname template if it is not set |
| strategy | object | `{"maxSurge":"15%","maxUnavailable":"10%","type":"RollingUpdate"}` | Defines deployment update strategy |
| strategy.maxSurge | string | `"15%"` | Optional argument to define maximum number of pods allowed over defined replicas |
| strategy.maxUnavailable | string | `"10%"` | Optional argument to define maximum number of ppods that can be unavailable during update |
| strategy.type | string | `"RollingUpdate"` | Type of strategy to use (Recreate or RollingUpdate) |
| topologySpreadConstraints.enabled | bool | `true` |  |
| topologySpreadConstraints.node.enabled | bool | `false` |  |
| topologySpreadConstraints.node.maxSkew | int | `1` |  |
| topologySpreadConstraints.specificYaml | string | `nil` | Specify custom topologySpreadConstraints yaml |
| topologySpreadConstraints.zone.enabled | bool | `true` |  |
| topologySpreadConstraints.zone.maxSkew | int | `1` |  |
| volumeMounts | list | `[]` | A list of volume mounts to be added to the pod |
| volumes | string | `nil` | A list of volumes to be added to the pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
