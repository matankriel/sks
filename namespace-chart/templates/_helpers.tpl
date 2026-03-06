{{/*
Full name combining release name and namespace name.
*/}}
{{- define "chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.namespace.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of the Secret holding the LDAP bind password.
Returns the existing secret name if provided, otherwise generates one.
*/}}
{{- define "ldapBindPasswordSecretName" -}}
{{- if .Values.ldap.existingBindPasswordSecret.name -}}
{{- .Values.ldap.existingBindPasswordSecret.name }}
{{- else -}}
{{- printf "%s-ldap-bind-password" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Key within the bind password Secret.
*/}}
{{- define "ldapBindPasswordSecretKey" -}}
{{- if .Values.ldap.existingBindPasswordSecret.key -}}
{{- .Values.ldap.existingBindPasswordSecret.key }}
{{- else -}}
password
{{- end }}
{{- end }}
