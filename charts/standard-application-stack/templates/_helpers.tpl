{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because sometimes Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mintel_common.fullname" -}}
{{- if .Values.nameOverride -}}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .component }}
{{- printf "%s-%s" .Values.global.name .component | trimSuffix .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Values.global.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Local DNS base */}}
{{- define "mintel_common.publicURL" -}}
{{- if .Values.ingress.tls }}
{{- printf "https://%s" .Values.ingress.defaultHost -}}
{{- else }}
{{- printf "http://%s" .Values.ingress.defaultHost -}}
{{- end }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mintel_common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* labelSelector block for affinity rules on pod name */}}
{{- define "mintel_common.affinityNameMatchExpression" -}}
matchExpressions:
  - key: app.kubernetes.io/name
    operator: In
    values:
      - {{ include "mintel_common.fullname" . }}
{{- end -}}

{{/* Common Annotations */}}
{{- define "mintel_common.commonAnnotations" -}}
helm.sh/chart: {{ include "mintel_common.chart" . }}
{{- end -}}

{{/* Common labels */}}
{{- define "mintel_common.labels" -}}
name: {{ include "mintel_common.fullname" . }}
{{ include "mintel_common.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.owner }}
app.mintel.com/owner: .Values.owner }}
{{- else if (and .Values.global .Values.global.owner) }}
app.mintel.com/owner: {{ .Values.global.owner }}
{{- end }}
app.mintel.com/env: {{ .Values.global.clusterEnv }}
{{- if (eq .Values.global.clusterEnv "local") }}
app.mintel.com/region: {{default "local" $.Values.global.clusterRegion }}
{{- else }}
app.mintel.com/region: {{default "${CLUSTER_REGION}" $.Values.global.clusterRegion }}
{{- end }}
{{- if .Values.global }}
{{- with .Values.global.additionalLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}
{{- with .Values.additionalLabels }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{/* Selector labels */}}
{{- define "mintel_common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mintel_common.fullname" . }}
{{- if .Values.partOf }}
app.kubernetes.io/part-of: {{ .Values.partOf }}
{{- else if (and .Values.global .Values.global.partOf) }}
app.kubernetes.io/part-of: {{ .Values.global.partOf }}
{{- end }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- else if .Values.component }}
app.kubernetes.io/component: {{ .Values.component }}
{{- else }}
app.kubernetes.io/component: app
{{- end }}
{{- end -}}

{{/* Service labels */}}
{{- define "mintel_common.serviceLabels" -}}
{{ include "mintel_common.labels" . }}
{{- with .Values.service.labels }}
{{- toYaml .}}
{{- end }}
{{- end -}}

{{/* Pod Target Labels */}}
{{- define "mintel_common.podTargetLabelNames" -}}
- app.kubernetes.io/name
- app.kubernetes.io/part-of
- app.kubernetes.io/component
- app.kubernetes.io/instance
- app.mintel.com/owner
{{- end -}}

{{/* Target Labels */}}
{{- define "mintel_common.targetLabelNames" -}}
- app.mintel.com/owner
- app.mintel.com/ignore_alerts
{{- end -}}

{{/*
Return the proper Application image name
*/}}
{{- define "mintel_common.image" -}}
{{- $registryName := "" }}
{{- if (eq .Values.global.clusterEnv "local") }}
{{- $registryName = default "k3d-default.localhost:5000" .Values.image.registry -}}
{{- else }}
{{- $registryName = default "registry.gitlab.com" .Values.image.registry -}}
{{- end }}
{{- $repositoryName := required "Must specify a docker repository." .Values.image.repository -}}
{{- $tag := default "auto-replaced" .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the ImagePullPolicy
*/}}
{{- define "mintel_common.imagePullPolicy" -}}
{{- if .Values.image.pullPolicy }}
{{- printf "%s" .Values.image.pullPolicy -}}
{{- else if (eq .Values.image.tag "latest") }}
{{- print "Always" -}}
{{- else }}
{{- print "IfNotPresent" -}}
{{- end }}
{{- end -}}


{{/*
Create a default app external secret name.
*/}}
{{- define "mintel_common.defaultAppSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-app" $fullname }}
{{- end -}}

{{/*
Create a default oauth external secret name.
*/}}
{{- define "mintel_common.defaultOauthSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-%s" $fullname (default "oauth" .Values.oauthProxy.secretSuffix) }}
{{- end -}}

{{/*
Create a default mariadb external secret name.
*/}}
{{- define "mintel_common.defaultMariadbSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-mariadb" $fullname }}
{{- end -}}

{{/*
Create a default postgresql external secret name.
*/}}
{{- define "mintel_common.defaultPostgresqlSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-postgresql" $fullname }}
{{- end -}}

{{/*
Create a default dynamodb external secret name.
*/}}
{{- define "mintel_common.defaultDynamodbSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-dynamodb" $fullname }}
{{- end -}}

{{/*
Create a default redis external secret name.
*/}}
{{- define "mintel_common.defaultRedisSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-redis" $fullname }}
{{- end -}}

{{/*
Create a default elasticsearch external secret name.
*/}}
{{- define "mintel_common.defaultElasticsearchSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-elasticsearch" $fullname }}
{{- end -}}

{{/*
Create a default opensearch external secret name.
*/}}
{{- define "mintel_common.defaultOpensearchSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-opensearch" $fullname }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mintel_common.imagePullSecrets" -}}
imagePullSecrets:
{{- if .Values.global }}
{{- with .Values.global.imagePullSecrets }}
{{- range . }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- with .Values.image.pullSecrets }}
{{- range . }}
  - name: {{ . }}
{{- end }}
{{- end }}
  - name: image-pull-gitlab
  - name: image-pull-docker-hub
{{- end -}}

{{/*
Build comma separated list of secrets
(primarily used to generate Stakater reloader annotations)
*/}}
{{- define "mintel_common.secretList" -}}
{{- $secretList := list -}}
{{- if (and .Values.externalSecret .Values.externalSecret.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultAppSecretName" .) .Values.externalSecret.nameOverride) -}}
{{- end }}
{{- if (and .Values.oauthProxy .Values.oauthProxy.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultOauthSecretName" .) .Values.oauthProxy.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.mariadb .Values.mariadb.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultMariadbSecretName" .) .Values.mariadb.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.dynamodb .Values.dynamodb.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultDynamodbSecretName" .) .Values.dynamodb.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.postgresql .Values.postgresql.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultPostgresqlSecretName" .) .Values.postgresql.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.redis .Values.redis.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultRedisSecretName" .) .Values.redis.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.elasticsearch .Values.elasticsearch.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultElasticsearchSecretName" .) .Values.elasticsearch.secretNameOverride) -}}
{{- end }}
{{- if (and .Values.opensearch .Values.opensearch.enabled) }}
{{- $secretList = append $secretList (default (include "mintel_common.defaultOpensearchSecretName" .) .Values.opensearch.secretNameOverride) -}}
{{- end }}
{{- range .Values.extraSecrets }}
{{- if (or (ne (hasKey . "includeInMain") true) .includeInMain) }}
{{- $secretList = append $secretList (default (printf "%s-%s" (include "mintel_common.fullname" $) .name) .nameOverride) -}}
{{- end }}
{{- end }}
{{- join "," $secretList -}}
{{- end -}}

{{/*
Build comma separated list of configmaps
(primarily used to generate Stakater reloader annotations)
*/}}
{{- define "mintel_common.configmapList" -}}
{{- $configmapList := list -}}
{{- if (and .Values.filebeatSidecar .Values.filebeatSidecar.enabled) }}
{{- $configmapList = append $configmapList (printf "%s-filebeat" (include "mintel_common.fullname" .)) }}
{{- end }}
{{- range .Values.configMaps }}
{{- $configmapList = append $configmapList (printf "%s-%s" (include "mintel_common.fullname" $) .name) }}
{{- end }}
{{- join "," $configmapList -}}
{{- end -}}

{{/* K8sNotify Annotations */}}
{{- define "mintel_common.k8snotify" -}}
{{- if (and .Values.k8snotify .Values.k8snotify.enabled) }}
app.mintel.com/k8s-notify.enabled: "true"
app.mintel.com/k8s-notify.logs-url: "https://grafana.mintel.cloud/explore?orgId=1&left=%5B%22now-24h%22,%22now%22,%22loki-eks-{{.Values.global.clusterEnv}}%22,%7B%22expr%22:%22%7Bjob%3D%5C%22{{.Release.Namespace}}%2F{{include "mintel_common.fullname" .}}%5C%22%7D%22,%22maxLines%22:null%7D%5D"
{{- if .Values.k8snotify.dashbordUrl }}
app.mintel.com/k8s-notify.monitoring-url: {{ .Values.k8snotify.dashboardUrl }}
{{- end }}
{{- if .Values.ingress.enabled }}
app.mintel.com/k8s-notify.public-url: {{ include "mintel_common.publicURL" . }}
{{- end }}
app.mintel.com/k8s-notify.receiver: {{ .Values.k8snotify.receiver }}
app.mintel.com/k8s-notify.team: {{ default .Values.global.owner .Values.k8snotify.team }}
{{- end }}
{{- end -}}

{{/* Outputs default env variables if local */}}
{{- define "mintel_common.defaultEnv" -}}
- name: APP_ENVIRONMENT
  value: {{ .Values.global.clusterEnv }}
- name: RUNTIME_ENVIRONMENT
  value: {{ .Values.global.runtimeEnvironment }}
{{- if .Values.kubelock.enabled }}
- name: KUBELOCK_NAME
  value: {{ default (include "mintel_common.fullname" .) .Values.kubelock.nameOverride }}
- name: KUBELOCK_NAMESPACE
  value: {{ .Release.Namespace }}
{{- end }}
{{- if (and .Values.ingress .Values.ingress.enabled) }}
{{- if .Values.ingress.tls }}
- name: USE_SSL
  value: "1"
{{- else }}
- name: USE_SSL
  value: "0"
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs common local dev env variables if local */}}
{{- define "mintel_common.localDevEnv" -}}
{{- if (eq .Values.global.clusterEnv "local") }}
- name: INIT_DB
  value: "1"
- name: SENTRY_DONT_SEND_EVENTS
  value: "1"
- name: DEBUG
  value: "1"
{{- end }}
{{- end -}}

{{/* Outputs redis env variables if local */}}
{{- define "mintel_common.redisEnv" -}}
{{- if (and .Values.redis .Values.redis.enabled) }}
{{- if (and (ne .Values.global.clusterEnv "local") (and .Values.redis.tls .Values.redis.tls.enabled)) }}
- name: REDIS_SSL
  value: "1"
{{- else }}
- name: REDIS_SSL
  value: "0"
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs mailhog env variable if local and mailhog enabled */}}
{{- define "mintel_common.mailhogEnv" -}}
{{- if (eq .Values.global.clusterEnv "local") }}
{{- if (and .Values.mailhog .Values.mailhog.enabled) }}
- name: USE_MAILHOG
  value: "1"
- name: EMAIL_HOST
  value: {{ printf "%s-mailhog" (include "mintel_common.fullname" .) | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs elasticsearch env variables if local */}}
{{- define "mintel_common.elasticsearchEnv" -}}
{{- if (eq .Values.global.clusterEnv "local") }}
{{- if (and .Values.elasticsearch .Values.elasticsearch.enabled) }}
- name: ES_NO_SSL
  value: "1"
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs opensearch env variables if local */}}
{{- define "mintel_common.opensearchEnv" -}}
{{- if (and .Values.opensearch .Values.opensearch.enabled) }}
- name: ES_USE_OPENSEARCH
  value: "1"
{{- if (eq .Values.global.clusterEnv "local") }}
- name: ES_NO_SSL
  value: "1"
{{- end }}
{{- if (and .Values.opensearch.awsEsProxy .Values.opensearch.awsEsProxy.enabled) }}
- name: ES_HOSTS
  value: {{ printf "http://%s-aws-es-proxy:9200" (include "mintel_common.fullname" .) }}
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs localstack env variables if local */}}
{{- define "mintel_common.localstackEnv" -}}
{{- if (eq .Values.global.clusterEnv "local") }}
{{- if (and .Values.localstack .Values.localstack.enabled) }}
{{- $endpoints := list -}}
{{- $services := (split "," .Values.localstack.startServices) -}}
{{- range $services -}}
{{- $endpoints = append $endpoints (printf "%s=http://%s-localstack:%s" (. | trim) (include "mintel_common.fullname" $) (default 4566 ($.Values.localstack.port | toString))) -}}
{{- end }}
- name: AWS_ENDPOINTS
  value: {{ join "," $endpoints }}
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs EXTRA_ALLOWED_HOSTS env variable */}}
{{- define "mintel_common.extraHostsEnv" -}}
{{- if (and .Values.ingress .Values.ingress.enabled) }}
- name: EXTRA_ALLOWED_HOSTS
  {{- $hosts := list .Values.ingress.defaultHost -}}
  {{- range .Values.ingress.extraHosts }}
  {{- $hosts = append $hosts .name -}}
  {{- end }}
  {{- if (and .Values.oauthProxy.enabled .Values.oauthProxy.ingressHost) -}}
  {{- $hosts = append $hosts .Values.oauthProxy.ingressHost }}
  {{- end }}
  value: {{ join "," $hosts }}
{{- end }}
{{- end -}}

{{/* Outputs topologySpreadConstraints block for a deployment */}}
{{- define "mintel_common.topologySpreadConstraints" -}}
{{- if (ne .Values.global.clusterEnv "local") }}
{{- if (gt (.Values.replicas | int) 1) }}
{{- if (and .Values.topologySpreadConstraints .Values.topologySpreadConstraints.enabled) }}
topologySpreadConstraints:
  {{- if .Values.topologySpreadConstraints.specificYaml }}
  {{- toYaml .Values.topologySpreadConstraints.specificYaml }}
  {{- end }}
  {{- if (and .Values.topologySpreadConstraints.zone .Values.topologySpreadConstraints.zone.enabled) }}
  - labelSelector:
      matchLabels: {{ include "mintel_common.selectorLabels" . | nindent 8 }}
    maxSkew: {{ default 1 .Values.topologySpreadConstraints.zone.maxSkew }}
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: {{ default "DoNotSchedule" .Values.topologySpreadConstraints.zone.whenUnsatisfiable }}
  {{- end }}
  {{- if or (and (not (kindIs "bool" .Values.topologySpreadConstraints.node.enabled)) (or (eq .Values.global.clusterEnv "logs") (eq .Values.global.clusterEnv "prod"))) (and .Values.topologySpreadConstraints.node .Values.topologySpreadConstraints.node.enabled) }}
  - labelSelector:
      matchLabels: {{ include "mintel_common.selectorLabels" . | nindent 8 }}
    maxSkew: {{ default 1 .Values.topologySpreadConstraints.node.maxSkew }}
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: {{ default "DoNotSchedule" .Values.topologySpreadConstraints.node.whenUnsatisfiable }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/* Outputs space separated list of endpoints to deny at ingress */}}
{{- define "mintel_common.ingressDenyEndpoints" -}}
{{- $endpoints := list }}
{{- $endpoints = append $endpoints (default "/metrics" .Values.metrics.path) }}
{{- if (ne .Values.ingress.allowLivenessUrl true) }}
{{- $livenessEndpoint := (coalesce .Values.liveness.path "/healthz") }}
{{- if (ne $livenessEndpoint .Values.ingress.blackbox.probePath) }}
{{- $endpoints = append $endpoints $livenessEndpoint }}
{{- end }}
{{- end }}
{{- if (ne .Values.ingress.allowReadinessUrl true) }}
{{- $readinessEndpoint := (coalesce .Values.readiness.path "/readiness") }}
{{- if (ne $readinessEndpoint .Values.ingress.blackbox.probePath) }}
{{- $endpoints = append $endpoints $readinessEndpoint }}
{{- end }}
{{- end }}
{{- print (join " " $endpoints) }}
{{- end -}}
