{{/* Supported resources */}}
{{- define "mintel_common.terraformCloudResources" -}}
{{- $terraformCloudResources := (list "memcached" "opensearch" "postgresql" "redis" "s3" "mariadb" "dynamodb" "sns" "sqs" "staticWebsite" "stepFunctionEks" "activeMQ" "auroraMySql" "auroraPostgresql" "sshKeyPairSecret") -}}
{{ join "," $terraformCloudResources }}
{{- end -}}

{{/* Supported resources that require IRSA */}}
{{- define "mintel_common.terraformCloudIRSAResources" -}}
{{- $terraformCloudIRSAResources := (list "opensearch" "s3" "dynamodb" "sns" "sqs") -}}
{{ join "," $terraformCloudIRSAResources }}
{{- end -}}

{{- define "mintel_common.terraform_cloud.irsaRequired"}}
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
{{- define "mintel_common.terraform_cloud.instanceConfigName" -}}
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

{{/* Default TF Cloud tags */}}
{{- define "mintel_common.terraform_cloud.tags" -}}
{{- printf "env:%s,owner:%s,mod:%s" .Global.clusterEnv .Global.owner (.ResourceType | kebabcase) -}}
{{- end -}}

{{/* Default TF Cloud Allow Destroy defaults */}}
{{- define "mintel_common.terraform_cloud.allow_destroy_default" -}}
{{- if ( has .Global.clusterEnv (list "prod" "logs")) }}
{{- false }}
{{- else }}
{{- true }}
{{- end -}}
{{- end }}

{{/* Operator extension Annotations */}}
{{- define "mintel_common.terraform_cloud.operatorAnnotations" -}}
{{/* ternary and hasKey functions are used instead of defaults below due to https://github.com/helm/helm/issues/3308 */}}
app.mintel.com/terraform-allow-destroy: {{ hasKey .InstanceCfg "workspaceAllowDestroy" | ternary .InstanceCfg.workspaceAllowDestroy (include "mintel_common.terraform_cloud.allow_destroy_default" .) | quote }}
app.mintel.com/terraform-owner: {{ .InstanceCfg.workspaceOwner | default .Global.owner }}
app.mintel.com/terraform-cloud-tags: {{ .InstanceCfg.workspaceTags | default (include "mintel_common.terraform_cloud.tags" .) | quote}}
{{- end -}}

{{/* Set variable values depending on environment */}}
{{- define "mintel_common.terraform_cloud.defaultVarValues" -}}
{{- $defaults := dict}}
{{/* rds and rds-aurora */}}
{{- if ( has .ResourceType (list "postgresql" "mariadb" "auroraMySql" "auroraPostgresql"))}}
    {{/* deletion_protection */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs" "qa"))) }}
    {{- $_ := set $defaults "enable_deletion_protection" false }}
    {{- end }}
    {{/* multi-az */}}
    {{- if ( has .Global.clusterEnv (list "prod" "logs")) }}
    {{- if ( has .ResourceType (list "postgresql" "mariadb")) }}
    {{- $_ := set $defaults "multi_az" true }}
    {{- end }}
    {{- if ( has .ResourceType (list "auroraMySql" "auroraPostgresql")) }}
    {{- $_ := set $defaults "instance_count" 2 }}
    {{- end }}
    {{- end }}
    {{/* backup retention period */}}
    {{- if ( eq .Global.clusterEnv "dev") }}
    {{- $_ := set $defaults "backup_retention_period" 2 }}
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
