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
{{- .Values.global.name | trunc 63 | trimSuffix "-" -}}
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
app.mintel.com/region: {{ $.Values.global.clusterRegion | default "local" }}
{{- else }}
app.mintel.com/region: {{ $.Values.global.clusterRegion | default "${CLUSTER_REGION}" }}
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
{{- toYaml . }}
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
{{- $registryName = .Values.image.registry | default "k3d-default.localhost:5000" -}}
{{- else }}
{{- $registryName = .Values.image.registry | default "registry.gitlab.com" -}}
{{- end }}
{{- $repositoryName := required "Must specify a docker repository." .Values.image.repository -}}
{{- $tag := .Values.image.tag | default "auto-replaced" | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the ImagePullPolicy
*/}}
{{- define "mintel_common.imagePullPolicy" -}}
{{- if .Values.image.pullPolicy }}
{{- .Values.image.pullPolicy -}}
{{- else if (eq .Values.image.tag "latest") -}}
Always
{{- else -}}
IfNotPresent
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
{{- printf "%s-%s" $fullname (.Values.oauthProxy.secretSuffix | default "oauth") }}
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
Create a default sqs external secret name.
*/}}
{{- define "mintel_common.defaultSqsSecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- printf "%s-sqs" $fullname }}
{{- end -}}

{{/*
Create a default s3 external secret name.
*/}}
{{- define "mintel_common.defaultS3SecretName" -}}
{{- $fullname := include "mintel_common.fullname" . }}
{{- if .Values.global.terraform.externalSecrets }}
{{- printf "mntl-%s-s3" $fullname }}
{{- else }}
{{- printf "%s-s3" $fullname }}
{{- end }}
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
{{- $secretList = append $secretList (.Values.externalSecret.nameOverride | default (include "mintel_common.defaultAppSecretName" .)) -}}
{{- end }}
{{- if (and .Values.oauthProxy .Values.oauthProxy.enabled) }}
{{- $secretList = append $secretList (.Values.oauthProxy.secretNameOverride | default (include "mintel_common.defaultOauthSecretName" .)) -}}
{{- end }}
{{- if (and (ne .Values.global.clusterEnv "local") .Values.global.terraform.externalSecrets) }}
  {{- range include "mintel_common.tf_cloud_external_secrets" . | split "," }}
     {{- if . }}
     {{- $secretList = append $secretList . -}}
     {{- end }}
  {{- end }}
{{- else }}
    {{- if (and .Values.mariadb .Values.mariadb.enabled) }}
    {{- $secretList = append $secretList (.Values.mariadb.secretNameOverride | default (include "mintel_common.defaultMariadbSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.dynamodb .Values.dynamodb.enabled) }}
    {{- $secretList = append $secretList (.Values.dynamodb.secretNameOverride | default (include "mintel_common.defaultDynamodbSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.postgresql .Values.postgresql.enabled) }}
    {{- $secretList = append $secretList (.Values.postgresql.secretNameOverride | default (include "mintel_common.defaultPostgresqlSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.redis .Values.redis.enabled) }}
    {{- $secretList = append $secretList (.Values.redis.secretNameOverride | default (include "mintel_common.defaultRedisSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.s3 .Values.s3.enabled) }}
    {{- $secretList = append $secretList (.Values.s3.secretNameOverride | default (include "mintel_common.defaultS3SecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.elasticsearch .Values.elasticsearch.enabled) }}
    {{- $secretList = append $secretList (.Values.elasticsearch.secretNameOverride | default (include "mintel_common.defaultElasticsearchSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.opensearch .Values.opensearch.enabled) }}
    {{- $secretList = append $secretList (.Values.opensearch.secretNameOverride | default (include "mintel_common.defaultOpensearchSecretName" .)) -}}
    {{- end }}
    {{- if (and .Values.sqs .Values.sqs.enabled) }}
    {{- $secretList = append $secretList (.Values.sqs.secretNameOverride | default (include "mintel_common.defaultSqsSecretName" .)) -}}
    {{- end }}
{{- end }}
{{- range .Values.extraSecrets }}
{{- if (or (ne (hasKey . "includeInMain") true) .includeInMain) }}
{{- $secretList = append $secretList (.nameOverride | default (printf "%s-%s" (include "mintel_common.fullname" $) .name) ) -}}
{{- end }}
{{- end }}
{{- $secretList | sortAlpha | uniq | compact | join "," -}}
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
{{- $configmapList | sortAlpha | uniq | compact | join "," -}}
{{- end -}}

{{/* Outputs Event Bus env variables */}}
{{- define "mintel_common.eventBusEnv" -}}
{{- if (and .Values.eventBus .Values.eventBus.enabled) }}
- name: EVENT_BUS_AWS_ACCOUNT_ID
  value: "{{ .Values.eventBus.accountId }}"
- name: EVENT_BUS_AWS_REGION
  value: {{ .Values.eventBus.region }}
- name: EVENT_BUS_MAX_WORKERS
  value: "{{ .Values.eventBus.maxWorkers }}"
- name: EVENT_BUS_SERVICE_NAME
  value: {{ .Values.eventBus.serviceName }}
{{- if .Values.eventBus.interactiveApp }}
- name: EVENT_BUS_INTERACTIVE_APP
  value: "1"
{{- end }}
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
  value: {{ .Values.kubelock.nameOverride | default (include "mintel_common.fullname" .) }}
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
  value: {{ $endpoints | sortAlpha | uniq | compact | join "," }}
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
  {{- range .Values.ingress.extraIngresses }}
    {{- $hosts = append $hosts .defaultHost -}}
    {{- range .extraHosts }}
    {{- $hosts = append $hosts .name -}}
    {{- end }}
  {{- end }}
  value: {{ $hosts | sortAlpha | uniq | compact | join "," }}
{{- end }}
{{- end -}}

{{/*
Outputs topologySpreadConstraints block for a deployment

This also takes into account autoscaling workloads which allow zero replicas.
Pod placement for such workloads is not important, since the pods are likely
to be short-lived (they are only to deal with spikes in queued work),
*/}}
{{- define "mintel_common.topologySpreadConstraints" -}}
{{- if (ne .Values.global.clusterEnv "local") }}
{{- if (gt (.Values.replicas | int) 1) }}
{{- if not (and .Values.autoscaling.enabled .Values.autoscaling.enableZeroReplicas) }}
{{- if (and .Values.topologySpreadConstraints .Values.topologySpreadConstraints.enabled) }}
topologySpreadConstraints:
  {{- if .Values.topologySpreadConstraints.specificYaml }}
  {{- toYaml .Values.topologySpreadConstraints.specificYaml }}
  {{- end }}
  {{- if (and .Values.topologySpreadConstraints.zone .Values.topologySpreadConstraints.zone.enabled) }}
  - labelSelector:
      matchLabels: {{ include "mintel_common.selectorLabels" . | nindent 8 }}
    maxSkew: {{ .Values.topologySpreadConstraints.zone.maxSkew | default 1 }}
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: {{ .Values.topologySpreadConstraints.zone.whenUnsatisfiable | default "DoNotSchedule" }}
  {{- end }}
  {{- if or (and (not (kindIs "bool" .Values.topologySpreadConstraints.node.enabled)) (or (eq .Values.global.clusterEnv "logs") (eq .Values.global.clusterEnv "prod"))) (and .Values.topologySpreadConstraints.node .Values.topologySpreadConstraints.node.enabled) }}
  - labelSelector:
      matchLabels: {{ include "mintel_common.selectorLabels" . | nindent 8 }}
    maxSkew: {{ .Values.topologySpreadConstraints.node.maxSkew | default 1 }}
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: {{ .Values.topologySpreadConstraints.node.whenUnsatisfiable | default "DoNotSchedule" }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/* Supported resources */}}
{{- define "mintel_common.terraformCloudResources" -}}
{{- $terraformCloudResources := (list "opensearch" "postgresql" "redis" "s3" "mariadb" "dynamodb" "sqs") -}}
{{ $terraformCloudResources | sortAlpha | uniq | compact | join ","}}
{{- end -}}

{{/* Set instanceConfig.Name */}}
{{- define "mintel_common.terraform_cloud.instanceConfigName" -}}
{{- $name := ""}}
{{- /* Use the instance config name if it is set explicitly */}}
{{- if ( hasKey .InstanceCfg "name" ) }}
  {{- $name = .InstanceCfg.name }}
{{- else }}
  {{- /* Use the app name if this is just a default resource setting */}}
  {{- if eq .InstanceName "default" }}
    {{- $name = .Global.name }}
  {{- else }}
    {{- /* Use the actual instance name otherwise */}}
    {{- $name = .InstanceName }}
  {{- end }}
{{- end }}
{{- /* If it is an S3 bucket, add the mntl- prefix if it does not exist */}}
{{- if ( and ( eq .ResourceType "s3") ( not (hasPrefix "mntl" $name)))}}
  {{- $name = (printf "mntl-%s" $name) }}
{{- end }}
{{ $name }}
{{- end -}}

{{/* Build list of TF cloud secrets */}}
{{- define "mintel_common.tf_cloud_external_secrets" -}}
{{- /* Initialize empty list that will contain the names of all TF Cloud secrets */}}
{{- $tfSecretList := list }}
{{- /* Loop through all supported Terraform Cloud resources */}}
{{- range $_, $resourceType := include "mintel_common.terraformCloudResources" $ | split "," }}
  {{- $global := $.Values.global }}
  {{- $resourceConfig := get $.Values $resourceType }}
  {{- /* Check if the resource is enabled and the output secret for it is as well */}}
  {{- if and $resourceConfig.enabled $resourceConfig.outputSecret }}
    {{- /* Loop through all instances of every resource type that is enabled and add the secret name to a list */}}
    {{- range $instanceName, $instanceConfig := $resourceConfig | dig "terraform" "instances" (dict "default" dict) }}
      {{- $instanceDict := dict "Global" $global "InstanceCfg" $instanceConfig "InstanceName" $instanceName "ResourceType" $resourceType }}
      {{- $_ := set $instanceConfig "name" (include "mintel_common.terraform_cloud.instanceConfigName" $instanceDict | trim)}}
      {{- $tfSecretList = append $tfSecretList (printf "%s-%s" ($instanceConfig.name | kebabcase) ($resourceType | kebabcase) ) }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $tfSecretList | sortAlpha | uniq | compact | join "," -}}
{{- end -}}

{{/* Return the name of the role used by the AWS Load Balancer Controller to read Okta secrets */}}
{{- define "mintel_common.okta.alb_controller_role_name" -}}
{{- $name := include "mintel_common.fullname" . }}
{{- print $name "-alb-controller-role" -}}
{{- end -}}
