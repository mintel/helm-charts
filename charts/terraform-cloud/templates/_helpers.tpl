{{- define "mintel_common.workspace" }}
{{- $ := index . 0 }}
{{- $instanceCfg := index . 2 }}
{{- $resourceType := index . 3 }}
{{- $moduleSource := index . 4 }}
{{- $moduleVersion := index . 5 }}
{{- $global := $.Values.global }}
{{- with index . 1 }}
apiVersion: app.terraform.io/v1alpha1
kind: Workspace
metadata:
  name: "{{ $global.clusterEnv }}-{{ $global.clusterRegion }}-{{ $global.clusterName }}-{{ $global.namespace }}-{{ .name }}-{{ $resourceType | kebabcase }}"
  namespace: {{ $.Release.Namespace | quote }}
  labels: {{ include "mintel_common.labels" $ | nindent 4 }}
  annotations:
    {{ include "mintel_common.commonAnnotations" $ | nindent 4 }}
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
spec:
  agentPoolID: {{ has $global.clusterEnv (list "prod" "logs") | ternary "apool-RhENdyZD1fV8Kdde" "apool-ARFKgcQQcY3T91bk" | quote }}
  module:
    source: {{ $moduleSource | quote }}
    version: {{ $moduleVersion | quote }}
  omitNamespacePrefix: true
  organization: {{ $global.terraform.organization | quote }}
  secretsMountPath: {{ $global.terraform.secretsMountPath | quote }}
  sshKeyID: "mintel-ssh"
  terraformVersion: {{ $global.terraform.terraformVersion | quote }}
  variables:
  {{- range $varKey, $varVal := $instanceCfg }}
    {{- if kindIs "map" $varVal}}
      {{- include "mintel_common.tfVar" (merge (dict "key" $varKey) $varVal) | indent 2 }}
    {{- else }}
      {{- include "mintel_common.tfVar" (dict "key" $varKey "value" $varVal) | indent 2 }}
    {{- end }}
  {{- end }}
  {{- include "mintel_common.tfVar" (dict "key" "tags" "value" (printf "{\n  Owner       = \"%s\"\n  Project     = \"%s\"\n  Application = \"%s\"\n}" $global.owner $global.partOf $global.name ) "hcl" true) | indent 2}}
  {{- include "mintel_common.tfVar" (dict "key" "aws_account_name" "value" $global.clusterEnv) | indent 2 }}
  {{- include "mintel_common.tfVar" (dict "key" "aws_region" "value" $global.clusterRegion) | indent 2 }}
  {{- include "mintel_common.tfVar" (dict "key" "eks_cluster_name" "value" $global.clusterName) | indent 2 }}
  {{- include "mintel_common.tfVar" (dict "key" "tfcloud_agent" "value" "true") | indent 2 }}
  {{- include "mintel_common.tfVar" (dict "key" "output_secret_name" "value" (printf "%s/%s/%s" $global.namespace .name $resourceType )) | indent 2 }}
  {{- include "mintel_common.tfVar" (dict "key" "secret_tags" "value" (printf "{access-project = \"%s-ops\"}" $global.namespace ) "hcl" true) | indent 2}}
{{- end }}
{{- end }}

{{- define "mintel_common.tfVar" }}
- key: {{ .key | quote }}
  value: {{ .value | quote }}
  environmentVariable: {{ .environmentVariable | default false}}
  hcl: {{ .hcl | default false }}
  sensitive: {{ .sensitive | default false}}
{{- end }}

{{- define "mintel_common.workspaceOutputSecret" }}
{{- $ := index . 0 }}
{{- $instanceCfg := index . 2 }}
{{- $resourceType := index . 3 }}
{{- $global := $.Values.global }}
{{- with index . 1 }}
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: "{{ $global.clusterEnv }}-{{ $global.clusterRegion }}-{{ $global.clusterName }}-{{ $global.namespace }}-{{ .name }}-{{ $resourceType | kebabcase }}"
  labels: {{ include "mintel_common.labels" $ | nindent 4 }}
  namespace: {{ $.Release.Namespace | quote }}
  annotations:
    {{ include "mintel_common.commonAnnotations" $ | nindent 4 }}
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
spec:
  dataFrom:
    - key: {{ (printf "%s/%s/%s" $global.namespace .name $resourceType ) }}
  refreshInterval: 5m0s
  secretStoreRef:
    name: aws-secrets-manager-default
    kind: SecretStore
  target:
    creationPolicy: Owner
{{- end }}
{{- end }}

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
{{- end -}}