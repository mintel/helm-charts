{{/* Defines oauth proxy sidecar container */}}
{{- define "mintel_common.oauthProxySidecar" -}}
{{- if (and .proxiedService.oauthProxy.enabled (ne .Values.global.clusterEnv "local")) }}
- name: oauth-proxy
  image: {{ default "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3" .proxiedService.oauthProxy.image }}
  imagePullPolicy: {{ default "IfNotPresent" .Values.image.pullPolicy }}
  args:
    - -redirect-url=https://{{ .proxiedService.ingressHost }}/oauth2/callback
    - -upstream=http://localhost:{{ .proxiedService.port }}
    - -http-address=http://0.0.0.0:4180
    - -provider=oidc
    - -skip-auth-regex=/ping
    - -skip-provider-button=true
    - -skip-jwt-bearer-tokens=true
    - -ssl-insecure-skip-verify=true
    - -ssl-upstream-insecure-skip-verify=true
    - -oidc-groups-claim=groups
    - -metrics-address=http://0.0.0.0:9090
    - -email-domain={{ default "*" .proxiedService.oauthProxy.emailDomain }}
    {{- with .proxiedService.oauthProxy.allowedGroups }}
    - -allowed-group={{ join "," . }}
    {{- end }}
    - -oidc-issuer-url=$(OIDC_ISSUER_URL)
    {{- if (eq .proxiedService.oauthProxy.type "portal") }}
    - -insecure-oidc-allow-unverified-email=true
    - -cookie-secure=false
    - -user-id-claim=sub
    - -scope=openid profile email
    {{- end }}
  envFrom:
    - secretRef:
        name: {{ default (printf "%s-%s" (include "mintel_common.fullname" .) .proxiedService.oauthProxy.secretSuffix) .proxiedService.oauthProxy.secretNameOverride }}
  ports:
    - containerPort: 4180
      name: oauth-proxy
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
