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
