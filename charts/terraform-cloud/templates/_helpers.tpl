{{- define "mintel_common.workspace" }}
{{- $ := index . 0 }}
{{- $instanceCfg := index . 2 }}
{{- $resourceType := index . 3 }}
{{- $moduleSource := index . 4 }}
{{- $moduleVersion := index . 5 }}
{{- with index . 1 }}
apiVersion: app.terraform.io/v1alpha1
kind: Workspace
metadata:
  name: "{{ $resourceType }}-{{ .name }}"
  namespace: {{ $.Release.Namespace | quote }}
spec:
  agentPoolID: "aws_{{ $.Values.global.clusterEnv }}"
  module:
    source: {{ $moduleSource | quote }}
    version: {{ $moduleVersion | quote }}
  organization: {{ $.Values.global.terraform.organization | quote }}
  secretsMountPath: {{ $.Values.global.terraform.secretsMountPath | quote }}
  sshKeyID: "mintel-ssh"
  terraformVersion: {{ $.Values.global.terraform.terraformVersion | quote }}
  variables:
  {{- range $varKey, $varVal := $instanceCfg }}
  {{- include "mintel_common.terraformVariable" (list $varKey $varVal) | indent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mintel_common.terraformVariable" }}
{{ $varKey := index . 0 }}
{{ $varVal := index . 1 }}
- key: {{ $varKey }}
  environmentVariable: false
  hcl: false
  sensitive: false
  value: {{ $varVal | quote }}
{{- end }}
