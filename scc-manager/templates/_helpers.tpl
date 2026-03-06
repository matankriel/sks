{{/*
ClusterRole name for a given SCC.
Usage: {{ include "scc.clusterRoleName" (dict "Release" .Release "sccName" $scc.name) }}
*/}}
{{- define "scc.clusterRoleName" -}}
{{- printf "%s-use-%s" .Release.Name .sccName }}
{{- end }}

{{/*
RoleBinding name for a given SCC/SA pair.
Usage: {{ include "scc.roleBindingName" (dict "Release" .Release "sccName" $scc.name "saName" $sa.name) }}
*/}}
{{- define "scc.roleBindingName" -}}
{{- printf "%s-%s-%s" .Release.Name .sccName .saName }}
{{- end }}
