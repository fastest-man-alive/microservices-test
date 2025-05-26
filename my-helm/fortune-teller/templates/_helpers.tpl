{{- define "fortune-teller.fullname" -}}
{{ .Release.Name }}
{{- end -}}

{{- define "fortune-teller.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
