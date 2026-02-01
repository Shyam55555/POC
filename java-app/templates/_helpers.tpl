{{- define "java-app.name" -}}
java-app
{{- end }}

{{- define "java-app.fullname" -}}
{{ include "java-app.name" . }}-{{ .Release.Name }}
{{- end }}

