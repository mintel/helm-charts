{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because sometimes Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mintel_common.fullname" -}}
{{- .Values.global.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common Annotations */}}
{{- define "mintel_common.commonAnnotations" -}}
helm.sh/chart: {{ include "mintel_common.chart" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mintel_common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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

{{/*
Create the name of the service account to use
*/}}
{{- define "aws-api-gateway-operator.serviceAccountName" -}}
{{- if (index .Values "standard-application-stack" "serviceAccount" "create") -}}
    {{ (index .Values "standard-application-stack" "serviceAccount" "name") | default (include "mintel_common.fullname" .) }}
{{- else -}}
    {{ (index .Values "standard-application-stack" "serviceAccount" "name") | default "default"  }}
{{- end -}}
{{- end -}}
