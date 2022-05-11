{{/* Defines oauth proxy sidecar container */}}
{{- define "mintel_common.oauthProxySidecar" -}}
{{- if (and .proxiedService.oauthProxy.enabled (ne .Values.global.clusterEnv "local")) }}
- name: auth-proxy
  image: {{ default "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3" .proxiedService.oauthProxy.image }}
  imagePullPolicy: {{ default "IfNotPresent" .Values.image.pullPolicy }}
  args:
    - --redirect-url=https://{{ .proxiedService.oauthProxy.ingressHost }}/oauth2/callback
    - --upstream=http://localhost:{{ .proxiedService.port }}
    - --http-address=http://0.0.0.0:4180
    - --provider=oidc
    - --skip-auth-regex=/ping
    {{- range .proxiedService.oauthProxy.skipAuthRegexes }}
    - --skip-auth-regex={{ . }}
    {{- end }}
    - --skip-provider-button=true
    - --skip-jwt-bearer-tokens=true
    - --ssl-insecure-skip-verify=true
    - --ssl-upstream-insecure-skip-verify=true
    - --oidc-groups-claim=groups
    - --metrics-address=http://0.0.0.0:9090
    - --email-domain={{ default "*" .proxiedService.oauthProxy.emailDomain }}
    {{- if .proxiedService.oauthProxy.emailDomain }}
    - --profile-url={{ default "https://oauth.mintel.com/userinfo/" (printf "%s/userinfo/" .proxiedService.oauthProxy.issuerUrl) .proxiedService.oauthProxy.profileUrl }}
    {{- end }}
    {{- with .proxiedService.oauthProxy.allowedGroups }}
    - --allowed-group={{ join "," . }}
    {{- end }}
    - --oidc-issuer-url={{ default "https://oauth.mintel.com" .proxiedService.oauthProxy.issuerUrl }}
    {{- if (eq .proxiedService.oauthProxy.type "portal") }}
    - --insecure-oidc-allow-unverified-email=true
    - --cookie-secure=false
    {{- if .proxiedService.oauthProxy.emailDomain }}
    - --user-id-claim={{ default "email" .proxiedService.oauthProxy.userIdClaim }}
    {{- else }}
    - --user-id-claim={{ default "sub" .proxiedService.oauthProxy.userIdClaim }}
    {{- end }}
    - --scope={{ default "openid profile email" .proxiedService.oauthProxy.scope }}
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
