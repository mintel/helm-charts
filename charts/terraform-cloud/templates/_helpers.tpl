{{/* Supported resources */}}
{{- define "mintel_common.terraformCloudResources" -}}
{{- $terraformCloudResources := (list "memcached" "opensearch" "postgresql" "redis" "s3" "mariadb" "dynamodb" "sns" "sqs" "staticWebsite") -}}
{{ join "," $terraformCloudResources }}
{{- end -}}

{{/* Supported resources that require IRSA */}}
{{- define "mintel_common.terraformCloudIRSAResources" -}}
{{- $terraformCloudIRSAResources := (list "opensearch" "s3" "dynamodb" "sns" "sqs") -}}
{{ join "," $terraformCloudIRSAResources }}
{{- end -}}

{{- define "mintel_common.irsaRequired"}}
{{- $irsaRequired := "false"}}
{{- range include "mintel_common.terraformCloudIRSAResources" $ | split "," }}
  {{- $resourceConfig := (get $.Values .) }}
  {{- if $resourceConfig.enabled }}
    {{- $irsaRequired = "true" }}
  {{- end }}
{{- end }}
{{$irsaRequired}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mintel_common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common Annotations */}}
{{- define "mintel_common.commonAnnotations" -}}
helm.sh/chart: {{ include "mintel_common.chart" . }}
{{- end -}}

{{/* Common labels */}}
{{- define "mintel_common.labels" -}}
app.mintel.com/owner: {{ .Values.global.owner }}
app.mintel.com/env: {{ .Values.global.clusterEnv }}
app.mintel.com/region: {{ .Values.global.clusterRegion }}
{{- with .Values.global.additionalLabels }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{/* Set instanceConfig.Name */}}
{{- define "mintel_common.instanceConfigName" -}}
{{- $name := ""}}
{{- if ( hasKey .InstanceCfg "name" ) }}
  {{- $name = .InstanceCfg.name }}
{{- else }}
  {{- if eq .InstanceName "default" }}
    {{- $name = .Global.name }}
  {{- else }}
    {{- $name = .InstanceName }}
  {{- end }}
{{- end }}
{{- if ( and ( eq .ResourceType "s3") ( not (hasPrefix "mntl" $name)))}}
  {{- $name = (printf "mntl-%s" $name) }}
{{- end }}
{{ $name }}
{{- end -}}

{{/* Set variable values depending on environment */}}
{{- define "mintel_common.defaultVarValues" -}}
{{- $defaults := dict}}
{{/* rds */}}
{{- if ( has .ResourceType (list "postgresql" "mariadb"))}}
    {{/* deletion_protection */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs" "qa"))) }}
    {{- $_ := set $defaults "enable_deletion_protection" false }}
    {{- end }}
    {{/* multi-az */}}
    {{- if ( has .Global.clusterEnv (list "prod" "logs")) }}
    {{- $_ := set $defaults "multi_az" false }}
    {{- end }}
    {{/* backup retention period */}}
    {{- if ( eq .Global.clusterEnv "dev") }}
    {{- $_ := set $defaults "backup_retention_period" 0 }}
    {{- end }}
    {{- if ( eq .Global.clusterEnv "qa") }}
    {{- $_ := set $defaults "backup_retention_period" 7 }}
    {{- end }}
{{- end }}
{{/* dynamoDB */}}
{{- if ( eq .ResourceType "dynamodb")}}
    {{/* point in time recovery */}}
    {{- if ( eq .Global.clusterEnv "dev") }}
    {{- $_ := set $defaults "point_in_time_recovery_enabled" false }}
    {{- end }}
{{- end }}
{{/* Opensearch */}}
{{- if ( eq .ResourceType "opensearch")}}
    {{/* instance count, zone_awareness_enabled and multi-az */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs"))) }}
    {{- $_ := set $defaults "instance_count" 1 }}
    {{- $_ := set $defaults "availability_zone_count" 1 }}
    {{- $_ := set $defaults "zone_awareness_enabled" false }}
    {{- end }}
{{- end }}
{{/* Redis */}}
{{- if ( eq .ResourceType "redis")}}
    {{/* multi-az, automatic_failover and replication_group_size */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs"))) }}
    {{- $_ := set $defaults "enable_multi_az" false }}
    {{- $_ := set $defaults "enable_automatic_failover" false }}
    {{- $_ := set $defaults "replication_group_size" 1 }}
    {{- end }}
{{- end }}
{{/* S3 */}}
{{- if ( eq .ResourceType "s3")}}
    {{/* versioning */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs"))) }}
    {{- $_ := set $defaults "enable_versioning" false }}
    {{- end }}
{{- end }}
{{- $defaults | toJson -}}
{{- end -}}
