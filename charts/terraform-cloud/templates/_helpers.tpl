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

{{/* Default AWS resource tags map (configurable) */}}
{{- define "mintel_common.terraform_cloud.defaultTags" -}}
{{- $ := index . 0 -}}
{{- $global := $.Values.global -}}
{{- $tags := dict -}}
{{- $cfg := (default (dict) (get $global.terraform "tags")) -}}
{{- $addBackstage := ternary $cfg.addBackstageComponentTag true (hasKey $cfg "addBackstageComponentTag") -}}
{{- $addRemaining := ternary $cfg.addDeprecatedTags true (hasKey $cfg "addDeprecatedTags") -}}
{{- if and $addBackstage $global.backstage.component }}
{{- /* Quote the key so downstream HCL uses "backstage.io/component" */ -}}
{{- $_ := set $tags "\"backstage.io/component\"" $global.backstage.component -}}
{{- end -}}
{{- if $addRemaining -}}
{{- $_ := set $tags "Owner" $global.owner -}}
{{- $_ := set $tags "Project" $global.partOf -}}
{{- $_ := set $tags "Application" (default $global.name $global.application) -}}
{{- $_ := set $tags "Component" (default $global.name $global.component) -}}
{{- end -}}
{{- toYaml $tags -}}
{{- end -}}

{{/* Supported resources */}}
{{- define "mintel_common.terraformCloudResources" -}}
{{- $terraformCloudResources := (list "activeMQ" "apiGatewayHttp" "auroraMySql" "auroraPostgresql" "cmsBackup" "datasync" "dynamodb" "extraIAM" "kinesis-firehose" "lambda" "mariadb" "memcached" "opensearch" "postgresql" "redis" "s3" "s3ReplicationRules" "s3MultiRegionAccessPoint" "sns" "sqs" "sshKeyPairSecret" "staticWebsite" "stepFunctionEks") -}}
{{ $terraformCloudResources | sortAlpha | uniq | compact | join "," }}
{{- end -}}

{{/* Supported resources that require IRSA */}}
{{- define "mintel_common.terraformCloudIRSAResources" -}}
{{- $terraformCloudIRSAResources := (list "opensearch" "s3" "s3MultiRegionAccessPoint" "dynamodb" "sns" "sqs") -}}
{{ $terraformCloudIRSAResources | sortAlpha | uniq | compact | join "," }}
{{- end -}}

{{- define "mintel_common.terraform_cloud.irsaRequired"}}
{{- $irsaRequired := "false"}}
{{- range include "mintel_common.terraformCloudIRSAResources" $ | split "," }}
  {{- $resourceConfig := (get $.Values .) }}
  {{- if $resourceConfig.enabled }}
    {{- $irsaRequired = "true" }}
  {{- end }}
{{- end }}
{{ $irsaRequired }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mintel_common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common Annotations */}}
{{- define "mintel_common.commonAnnotations" -}}
app.mintel.com/placeholder: placeholder
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

{{/* Operator extension Annotations */}}
{{- define "mintel_common.terraform_cloud.tfCloudOperatorExtentionAnnotations" -}}
app.mintel.com/terraform-owner: {{ .InstanceCfg.workspaceOwner | default .Global.owner }}
app.mintel.com/terraform-cloud-tags: {{ .InstanceCfg.workspaceTags | default (include "mintel_common.terraform_cloud.tags" .) | quote }}
app.mintel.com/terraform-allow-destroy: {{ (include "mintel_common.terraform_cloud.allow_destroy" .) | quote -}}
{{- end -}}

{{/* Default TF Cloud Allow Destroy defaults */}}
{{- define "mintel_common.terraform_cloud.allow_destroy" }}

{{- if hasKey .InstanceCfg "workspaceAllowDestroy" -}}
  {{- .InstanceCfg.workspaceAllowDestroy -}}
{{ else }}
  {{- if hasKey .Global.terraform "defaultWorkspaceAllowDestroy" }}
    {{- .Global.terraform.defaultWorkspaceAllowDestroy -}}
  {{- else }}
    {{- if ( has .Global.clusterEnv (list "prod" "logs")) }}
      {{- false -}}
    {{ else }}
      {{- true -}}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}


{{/* Set variable values depending on environment */}}
{{- define "mintel_common.terraform_cloud.defaultVarValues" -}}
{{- $defaults := dict }}
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
    {{/* deletion_protection */}}
    {{- if ( not ( has .Global.clusterEnv (list "prod" "logs"))) }}
    {{- $_ := set $defaults "deletion_protection_enabled" false }}
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

{{/* Convert dict to hcl */}}
{{- define "mintel_common.terraform_cloud.dict_to_hcl" -}}
{{- range $key, $value := . }}
{{- if $value -}}
{{- printf "  %s = \"%s\"\n" $key $value -}}
{{- end -}}
{{ end }}
{{- end -}}
