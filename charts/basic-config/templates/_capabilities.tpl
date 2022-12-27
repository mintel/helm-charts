{{/* vim: set filetype=mustache: */}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "common.capabilities.kubeVersion" -}}
{{- if .Values.global }}
    {{- if .Values.global.kubeVersion }}
    {{- .Values.global.kubeVersion -}}
    {{- else }}
    {{- .Values.kubeVersion | default .Capabilities.KubeVersion.Version -}}
    {{- end -}}
{{- else }}
{{- .Values.kubeVersion | default .Capabilities.KubeVersion.Version -}}
{{- end -}}
{{- end -}}

{{/* Return the appropriate apiVersion for RBAC resources. */}}
{{- define "common.capabilities.rbac.apiVersion" -}}
rbac.authorization.k8s.io/v1
{{- end -}}

{{/* Return the appropriate apiVersion for External Secrets. */}}
{{- define "common.capabilities.externalsecret.apiVersion" -}}
external-secrets.io/v1alpha1
{{- end -}}

{{/* Return the appropriate apiVersion for Secrets. */}}
{{- define "common.capabilities.secret.apiVersion" -}}
v1
{{- end -}}

{{/* Return the appropriate apiVersion for Configmaps */}}
{{- define "common.capabilities.configmap.apiVersion" -}}
v1
{{- end -}}

{{/* Return the appropriate apiVersion for Service Accounts. */}}
{{- define "common.capabilities.serviceaccount.apiVersion" -}}
v1
{{- end -}}

{{/* Return the appropriate apiVersion for Services. */}}
{{- define "common.capabilities.service.apiVersion" -}}
v1
{{- end -}}

{{/* Return the appropriate apiVersion for NetworkPolicy. */}}
{{- define "common.capabilities.networkpolicy.apiVersion" -}}
networking.k8s.io/v1
{{- end -}}


{{/*
Returns true if the used Helm version is 3.3+.
A way to check the used Helm version was not introduced until version 3.3.0 with .Capabilities.HelmVersion, which contains an additional "{}}"  structure.
This check is introduced as a regexMatch instead of {{ if .Capabilities.HelmVersion }} because checking for the key HelmVersion in <3.3 results in a "interface not found" error.
**To be removed when the catalog's minimun Helm version is 3.3**
*/}}
{{- define "common.capabilities.supportsHelmVersion" -}}
{{- if regexMatch "{(v[0-9])*[^}]*}}$" (.Capabilities | toString ) }}
  {{- true -}}
{{- end -}}
{{- end -}}
