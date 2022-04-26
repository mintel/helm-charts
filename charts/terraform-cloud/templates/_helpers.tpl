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
  {{- include "mintel_common.terraformVariable" (dict "key" $varKey "value" $varVal) | indent 2 }}
  {{- end }}
  {{- include "mintel_common.tagsTerraformVariable" $.Values.global | indent 2 }}
{{- end }}
{{- end }}

{{- define "mintel_common.terraformVariable" }}
- key: {{ .key | quote }}
  value: {{ .value | quote }}
  environmentVariable: {{ .environmentVariable | default false}}
  hcl: {{ .hcl | default false }}
  sensitive: {{ .sensitive | default false}}
{{- end }}

{{- define "mintel_common.tagsTerraformVariable" }}
{{- $varKey := "tags" }}
{{- $varVal := (printf "{\n  Owner       = \"%s\"\n  Project     = \"%s\"\n  Application = \"%s\"\n}" .owner .partOf .name ) }}
{{- include "mintel_common.terraformVariable" (dict "key" $varKey "value" $varVal "hcl" true) }}
{{- end }}
