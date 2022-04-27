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
  name: "{{ $resourceType }}-{{ .name }}"
  namespace: {{ $.Release.Namespace | quote }}
spec:
  agentPoolID: "aws_{{ $global.clusterEnv }}"
  module:
    source: {{ $moduleSource | quote }}
    version: {{ $moduleVersion | quote }}
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
  {{- include "mintel_common.tfVar" (dict "key" "region" "value" $global.clusterRegion) | indent 2 }}
{{- end }}
{{- end }}

{{- define "mintel_common.tfVar" }}
- key: {{ .key | quote }}
  value: {{ .value | quote }}
  environmentVariable: {{ .environmentVariable | default false}}
  hcl: {{ .hcl | default false }}
  sensitive: {{ .sensitive | default false}}
{{- end }}
