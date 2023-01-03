{{/* Defines oauth proxy sidecar container */}}
{{- define "mintel_common.oauthProxySidecar" -}}
{{- if (and .proxiedService.oauthProxy.enabled (ne .Values.global.clusterEnv "local")) }}
- name: auth-proxy
  image: {{ .proxiedService.oauthProxy.image | default "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3" }}
  imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" }}
  args:
    - --redirect-url=https://{{ .proxiedService.oauthProxy.ingressHost | default .Values.ingress.defaultHost }}/oauth2/callback
    - --upstream=http://localhost:{{ .proxiedService.port }}
    - --http-address=http://0.0.0.0:4180
    - --provider=oidc
    - --skip-auth-regex=^/ping$
    - --skip-auth-regex=^{{ .Values.liveness.path | default "/healthz" }}$
    - --skip-auth-regex=^{{ .Values.readiness.path | default "/readiness" }}$
    - --skip-auth-regex=^{{ .Values.ingress.blackbox.probePath | default "/external-health-check" }}$
    {{- range .proxiedService.oauthProxy.skipAuthRegexes }}
    - --skip-auth-regex={{ if not (hasPrefix "^" . )}}^{{ end }}{{ . }}{{ if not (hasSuffix "$" . )}}${{ end }}
    {{- end }}
    - --skip-provider-button=true
    - --skip-jwt-bearer-tokens=true
    - --ssl-insecure-skip-verify=true
    - --ssl-upstream-insecure-skip-verify=true
    - --oidc-groups-claim=groups
    - --metrics-address=http://0.0.0.0:9090
    - --email-domain={{ .proxiedService.oauthProxy.emailDomain | default "*" }}
    {{- if .proxiedService.oauthProxy.emailDomain }}
    - --profile-url={{ coalesce (printf "%s/userinfo/" .proxiedService.oauthProxy.issuerUrl) .proxiedService.oauthProxy.profileUrl "https://oauth.mintel.com/userinfo/" }}
    {{- end }}
    {{- with .proxiedService.oauthProxy.allowedGroups }}
    - --allowed-group={{ . | sortAlpha | uniq | compact | join "," }}
    {{- end }}
    - --oidc-issuer-url={{ .proxiedService.oauthProxy.issuerUrl | default "https://oauth.mintel.com" }}
    {{- if (eq .proxiedService.oauthProxy.type "portal") }}
    - --insecure-oidc-allow-unverified-email=true
    - --cookie-secure=false
    {{- if .proxiedService.oauthProxy.emailDomain }}
    - --user-id-claim={{ .proxiedService.oauthProxy.userIdClaim | default "email" }}
    {{- else }}
    - --user-id-claim={{ .proxiedService.oauthProxy.userIdClaim | default "sub" }}
    {{- end }}
    - --scope={{ .proxiedService.oauthProxy.scope | default "openid profile email" }}
    {{- end }}
  env:
    {{- with .proxiedService.oauthProxy.env }}
    {{- toYaml . | nindent 12 }}
    {{- end }}
  envFrom:
    - secretRef:
        {{- if .proxiedService.oauthProxy.secretNameOverride }}
        name: {{ .proxiedService.oauthProxy.secretNameOverride }}
        {{- else if .proxiedService.oauthProxy.secretSuffix }}
        name: {{ printf "%s-%s" (include "mintel_common.fullname" .) .proxiedService.oauthProxy.secretSuffix }}
        {{- else }}
        name: {{ printf "%s-oauth" (include "mintel_common.fullname" .) }}
        {{- end }}
  ports:
    - containerPort: 4180
      name: auth-proxy
    - containerPort: 9090
      name: metrics
  livenessProbe:
    httpGet:
      path: /ping
      port: auth-proxy
      scheme: HTTP
  readinessProbe:
    httpGet:
      path: /ping
      port: auth-proxy
      scheme: HTTP
  resources:
    {{- if .proxiedService.oauthProxy.resources }}
    {{- toYaml .proxiedService.oauthProxy.resources | nindent 4 }}
    {{- else }}
    limits:
      cpu: 200m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 64Mi
    {{- end }}
{{- end }}
{{- end -}}
