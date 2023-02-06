# aws-api-gateway-operator

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.2](https://img.shields.io/badge/AppVersion-v1.0.2-informational?style=flat-square)

AWS API Gateway Operator Helm chart for Kubernetes

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://mintel.github.io/helm-charts | standard-application-stack | 3.58.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"additionalLabels":{},"cloudProvider":{"accountId":""},"clusterDomain":"127.0.0.1.nip.io","clusterEnv":"${CLUSTER_ENV}","clusterName":"${CLUSTER_NAME}","name":"aws-api-gateway-operator","owner":"SRE","partOf":"aws-api-gateway-operator","runtimeEnvironment":"kubernetes"}` | Global variables for us in all charts and sub charts |
| global.additionalLabels | object | `{}` | Additional labels to apply to all resources |
| global.cloudProvider | object | `{"accountId":""}` | Global variables relating to cloud provider |
| global.cloudProvider.accountId | string | `""` | AWS Account Id |
| global.clusterDomain | string | `"127.0.0.1.nip.io"` | Kubernetes cluster domain |
| global.clusterEnv | string | `"${CLUSTER_ENV}"` | Environment (local, dev, qa, prod) |
| global.clusterName | string | `"${CLUSTER_NAME}"` | Kubernetes cluster name |
| global.name | string | `"aws-api-gateway-operator"` | Name of the application |
| global.owner | string | `"SRE"` | Team which "owns" the application |
| global.partOf | string | `"aws-api-gateway-operator"` | Top level application each deployment is a part of |
| global.runtimeEnvironment | string | `"kubernetes"` | Global variable definint RUNTIME_ENVIRONMENT |
| rbac | object | `{"create":true}` | Specifies whether rbac resources should be created |
| standard-application-stack | object | `{"affinity":{"enabled":false,"podAntiAffinity":{"node":"soft","zone":"hard"}},"args":["--aws-region=${CLUSTER_REGION}","--zap-development-config=false"],"command":["/app/manager"],"configMaps":[],"env":[],"envFrom":[],"externalSecret":{"enabled":false},"extraContainers":[],"extraInitContainers":[],"extraPorts":[],"extraSecrets":[],"image":{"pullPolicy":"IfNotPresent","registry":"registry.gitlab.com","repository":"mintel/satoshi/tools/aws-api-gateway-operator","tag":"v1.0.2"},"imagePullSecrets":[],"ingress":{"alb":{"backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","deregistrationDelay":{"timeoutSeconds":5},"enabled":false,"healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing"},"allowLivenessUrl":false,"allowReadinessUrl":false,"blackbox":{"enabled":true,"probePath":"/external-health-check"},"enabled":false,"extraAnnotations":{},"extraHosts":[],"specificRulesHostsYaml":{},"specificTlsHostsYaml":{},"tls":true},"liveness":{"enabled":true,"initialDelaySeconds":15,"methodOverride":{"httpGet":{"path":"/healthz","port":8081,"scheme":"HTTP"}},"path":"/healthz","periodSeconds":20,"startup":{"failureThreshold":60,"periodSeconds":5}},"metrics":{"additionalMonitors":[],"basicAuth":{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""},"enabled":true},"minReadySeconds":10,"networkPolicy":{"additionalAllowFroms":[],"enabled":true},"persistentVolumes":null,"podAnnotations":{},"podDisruptionBudget":{"enabled":true,"minAvailable":"50%"},"podSecurityContext":{"runAsUser":1000},"port":9443,"priorityClassName":"infra","readiness":{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"methodOverride":{"httpGet":{"path":"/readyz","port":8081,"scheme":"HTTP"}},"path":"/readyz","timeoutSeconds":3},"replicas":2,"resources":{"limits":{"cpu":"1","memory":"256Mi"},"requests":{"cpu":"5m","memory":"50Mi"}},"securityContext":{},"service":{"annotations":{},"enabled":true,"labels":{},"type":"ClusterIP"},"serviceAccount":{"annotations":{},"automountServiceAccountToken":true,"clusterRoles":[],"create":true,"irsa":{"enabled":true,"nameOverride":""},"name":"","roles":[]},"singleReplicaOnly":false,"strategy":{"maxSurge":"15%","maxUnavailable":"10%","type":"RollingUpdate"},"terminationGracePeriodSeconds":30,"topologySpreadConstraints":{"enabled":true,"node":{"enabled":null,"maxSkew":1},"specificYaml":null,"zone":{"enabled":true,"maxSkew":1}},"volumeMounts":[],"volumes":null}` | values for the standard-application-stack subchart |
| standard-application-stack.affinity | object | `{"enabled":false,"podAntiAffinity":{"node":"soft","zone":"hard"}}` | Configure the deployment affinity/anti-affinity rules ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| standard-application-stack.affinity.enabled | bool | `false` | Set to true to enable deployment affinity rules |
| standard-application-stack.affinity.podAntiAffinity | object | `{"node":"soft","zone":"hard"}` | Configure pod anti-affinity rules |
| standard-application-stack.affinity.podAntiAffinity.node | string | `"soft"` | Toggle whether node affinity should be required (hard) or preferred (soft) |
| standard-application-stack.affinity.podAntiAffinity.zone | string | `"hard"` | Toggle whether zone affinity should be required (hard) or preferred (soft) |
| standard-application-stack.args | list | `["--aws-region=${CLUSTER_REGION}","--zap-development-config=false"]` | Optional arguments to the container |
| standard-application-stack.command | list | `["/app/manager"]` | Optional command to the container |
| standard-application-stack.configMaps | list | `[]` | A list of configuration maps for this application |
| standard-application-stack.env | list | `[]` | Optional environment variables injected into the container |
| standard-application-stack.envFrom | list | `[]` | Optional environment variables injected into the container using envFrom (secrets/configmaps) |
| standard-application-stack.externalSecret | object | `{"enabled":false}` | Define ExternalSecret from AWS ref: https://github.com/external-secrets/kubernetes-external-secrets |
| standard-application-stack.extraContainers | list | `[]` | Enable extraContainers (oauth2-proxy is a common example) |
| standard-application-stack.extraInitContainers | list | `[]` | Enable extra init-containers |
| standard-application-stack.extraPorts | list | `[]` | Optional list of extra container ports to configure |
| standard-application-stack.image | object | `{"pullPolicy":"IfNotPresent","registry":"registry.gitlab.com","repository":"mintel/satoshi/tools/aws-api-gateway-operator","tag":"v1.0.2"}` | Docker image values |
| standard-application-stack.image.pullPolicy | string | `"IfNotPresent"` | Optional ImagePullPolicy ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images |
| standard-application-stack.image.registry | string | `"registry.gitlab.com"` | Docker registry used to pull application image |
| standard-application-stack.image.repository | string | `"mintel/satoshi/tools/aws-api-gateway-operator"` | Docker repository |
| standard-application-stack.image.tag | string | `"v1.0.2"` | Container image tag |
| standard-application-stack.imagePullSecrets | list | `[]` | Optional array of imagePullSecrets ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| standard-application-stack.ingress | object | `{"alb":{"backendProtocol":"HTTP","backendProtocolVersion":"HTTP1","deregistrationDelay":{"timeoutSeconds":5},"enabled":false,"healthcheck":{"healthyThresholdCount":2,"intervalSeconds":15,"protocol":"HTTP","timeoutSeconds":5,"unhealthyThresholdCount":2},"preStopDelay":{"delaySeconds":15,"enabled":true},"scheme":"internet-facing"},"allowLivenessUrl":false,"allowReadinessUrl":false,"blackbox":{"enabled":true,"probePath":"/external-health-check"},"enabled":false,"extraAnnotations":{},"extraHosts":[],"specificRulesHostsYaml":{},"specificTlsHostsYaml":{},"tls":true}` | Configure the ingress resource that allows you to access the application from public-internet ref: http://kubernetes.io/docs/user-guide/ingress/ |
| standard-application-stack.ingress.alb.backendProtocol | string | `"HTTP"` | Application Version (HTTP / HTTPS) |
| standard-application-stack.ingress.alb.backendProtocolVersion | string | `"HTTP1"` | Application Protocol Version (HTTP1 / HTTP2 / GRPC) |
| standard-application-stack.ingress.alb.healthcheck.healthyThresholdCount | int | `2` | Success threshold |
| standard-application-stack.ingress.alb.healthcheck.intervalSeconds | int | `15` | Period seconds |
| standard-application-stack.ingress.alb.healthcheck.protocol | string | `"HTTP"` | Healthcheck protocol |
| standard-application-stack.ingress.alb.healthcheck.timeoutSeconds | int | `5` | Timeout seconds |
| standard-application-stack.ingress.alb.healthcheck.unhealthyThresholdCount | int | `2` | Failure threshold |
| standard-application-stack.ingress.alb.preStopDelay.delaySeconds | int | `15` | The delay (sleep) to wait for. IMPORTANT: The terminationGracePeriodSeconds must be greater than this. |
| standard-application-stack.ingress.alb.preStopDelay.enabled | bool | `true` | Enable an additional delay when the container is shutdown of delaySeconds. This allows ALB to fully de-register the pod (allows zero-downtime rollouts) |
| standard-application-stack.ingress.alb.scheme | string | `"internet-facing"` | Public or private alb (internet-facing / internal) |
| standard-application-stack.ingress.allowLivenessUrl | bool | `false` | Set to true to allow the liveness URL through the ingress |
| standard-application-stack.ingress.allowReadinessUrl | bool | `false` | Set to true to allow the readiness URL through the ingress |
| standard-application-stack.ingress.blackbox | object | `{"enabled":true,"probePath":"/external-health-check"}` | Configures annotations defining blackbox endpoints |
| standard-application-stack.ingress.blackbox.enabled | bool | `true` | Set to true to tell blackboxes to hit endpoint |
| standard-application-stack.ingress.blackbox.probePath | string | `"/external-health-check"` | Endpoint for blackboxes to hit |
| standard-application-stack.ingress.enabled | bool | `false` | Set to true to enable ingress record generation |
| standard-application-stack.ingress.extraAnnotations | object | `{}` | Additional Ingress annotations For a full list of possible ingress annotations, please see ref: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md |
| standard-application-stack.ingress.extraHosts | list | `[]` | List of extra ingress hosts to setup |
| standard-application-stack.ingress.specificRulesHostsYaml | object | `{}` | Optional ingress Rules Hosts Yaml that doesn't fit standard pattern |
| standard-application-stack.ingress.specificTlsHostsYaml | object | `{}` | Optional ingress Tls Hosts Yaml that doesn't fit standard pattern |
| standard-application-stack.ingress.tls | bool | `true` | Enable TLS configuration for the hostname defined at ingress.hostname parameter |
| standard-application-stack.liveness.methodOverride.httpGet.path | string | `"/healthz"` | Request path for readinessProbe |
| standard-application-stack.liveness.methodOverride.httpGet.port | int | `8081` | Port for readinessProbe |
| standard-application-stack.liveness.methodOverride.httpGet.scheme | string | `"HTTP"` | Scheme (HTTP or HTTPS) |
| standard-application-stack.liveness.startup.failureThreshold | int | `60` | Failure threshold for startupProbe |
| standard-application-stack.liveness.startup.periodSeconds | int | `5` | Perios seconds for startupProbe |
| standard-application-stack.metrics | object | `{"additionalMonitors":[],"basicAuth":{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""},"enabled":true}` | Prometheus Exporter / Metrics |
| standard-application-stack.metrics.basicAuth | object | `{"enabled":false,"passwordKey":"","secretName":"","usernameKey":""}` | Scheme (HTTP ot HTTPS)  scheme: HTTP |
| standard-application-stack.metrics.enabled | bool | `true` | Enable Prometheus to access aplpication metrics endpoints |
| standard-application-stack.minReadySeconds | int | `10` | Minimum number of seconds before deployments are ready |
| standard-application-stack.networkPolicy | object | `{"additionalAllowFroms":[],"enabled":true}` | Define a default NetworkPolicy for allowing apps in the same 'app.kubernetes.io/part-of' group to communicate with eachother. ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| standard-application-stack.persistentVolumes | string | `nil` | A list of persistent volume claims to be added to the pod |
| standard-application-stack.podAnnotations | object | `{}` | Additional annotations to apply to the pod |
| standard-application-stack.podDisruptionBudget | object | `{"enabled":true,"minAvailable":"50%"}` | Pod Disruption Budget ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| standard-application-stack.podSecurityContext | object | `{"runAsUser":1000}` | Pod Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| standard-application-stack.port | int | `9443` | Set port to null to skip adding container Ports |
| standard-application-stack.priorityClassName | string | `"infra"` | Optional name of PriorityClass to run pods with |
| standard-application-stack.readiness | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"methodOverride":{"httpGet":{"path":"/readyz","port":8081,"scheme":"HTTP"}},"path":"/readyz","timeoutSeconds":3}` | Configure extra options for readiness probe ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes |
| standard-application-stack.readiness.methodOverride.httpGet.path | string | `"/readyz"` | Request path for readinessProbe |
| standard-application-stack.readiness.methodOverride.httpGet.port | int | `8081` | Port for readinessProbe |
| standard-application-stack.readiness.methodOverride.httpGet.scheme | string | `"HTTP"` | Scheme (HTTP or HTTPS) |
| standard-application-stack.replicas | int | `2` | Desired number of replicas for main deployment |
| standard-application-stack.resources | object | `{"limits":{"cpu":"1","memory":"256Mi"},"requests":{"cpu":"5m","memory":"50Mi"}}` | Container resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources |
| standard-application-stack.securityContext | object | `{}` | Security context for the container ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| standard-application-stack.service | object | `{"annotations":{},"enabled":true,"labels":{},"type":"ClusterIP"}` | Kubernetes svc configutarion |
| standard-application-stack.service.annotations | object | `{}` | Annotations to add to service |
| standard-application-stack.service.enabled | bool | `true` | Whether to create Service resource or not |
| standard-application-stack.service.labels | object | `{}` | Provide any additional labels which may be required. |
| standard-application-stack.service.type | string | `"ClusterIP"` | Kubernetes Service type |
| standard-application-stack.serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"clusterRoles":[],"create":true,"irsa":{"enabled":true,"nameOverride":""},"name":"","roles":[]}` | ServiceAccount parameters ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| standard-application-stack.serviceAccount.annotations | object | `{}` | Additional Service Account annotations |
| standard-application-stack.serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automount the service account token or not |
| standard-application-stack.serviceAccount.clusterRoles | list | `[]` | Define list of ClusterRole's to create and bind to the service account ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/ |
| standard-application-stack.serviceAccount.create | bool | `true` | Determine whether a Service Account should be created or it should reuse a exiting one. |
| standard-application-stack.serviceAccount.irsa | object | `{"enabled":true,"nameOverride":""}` | Configures IRSA for the Service Account |
| standard-application-stack.serviceAccount.irsa.enabled | bool | `true` | Determines whether service account is IRSA enabled |
| standard-application-stack.serviceAccount.irsa.nameOverride | string | `""` | Override for last component of role-arn, ie: accountid-clusterName-namespace-{nameOverride} |
| standard-application-stack.serviceAccount.name | string | `""` | ServiceAccount to use. A name is generated using the mintel_common.fullname template if it is not set |
| standard-application-stack.serviceAccount.roles | list | `[]` | Define list of Role's to create and bind to the service account ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/ |
| standard-application-stack.singleReplicaOnly | bool | `false` | Explicitly stating that a single replica is required Should only be used if the image truly can't be run multiple times usually involving third party apps or prometheus exporters, etc |
| standard-application-stack.strategy | object | `{"maxSurge":"15%","maxUnavailable":"10%","type":"RollingUpdate"}` | Defines deployment update strategy |
| standard-application-stack.strategy.maxSurge | string | `"15%"` | Optional argument to define maximum number of pods allowed over defined replicas |
| standard-application-stack.strategy.maxUnavailable | string | `"10%"` | Optional argument to define maximum number of pods that can be unavailable during update |
| standard-application-stack.strategy.type | string | `"RollingUpdate"` | Type of strategy to use (Recreate or RollingUpdate) |
| standard-application-stack.terminationGracePeriodSeconds | int | `30` | Configure terminationGracePeriodSeconds ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/ |
| standard-application-stack.topologySpreadConstraints.node.enabled | string | `nil` | Set this to true/false to override the default behaviour (enabled for prod only) |
| standard-application-stack.topologySpreadConstraints.specificYaml | string | `nil` | Specify custom topologySpreadConstraints yaml |
| standard-application-stack.volumeMounts | list | `[]` | A list of volume mounts to be added to the pod |
| standard-application-stack.volumes | string | `nil` | A list of volumes to be added to the pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
