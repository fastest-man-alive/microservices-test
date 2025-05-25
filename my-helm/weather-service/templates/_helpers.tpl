{{- define "weather-service.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "weather-service.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

{{- define "weather-service.labels" -}}
app.kubernetes.io/name: {{ include "weather-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "weather-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "weather-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
