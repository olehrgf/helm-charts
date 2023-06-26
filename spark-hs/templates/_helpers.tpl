{{/*
Default name of the Chart (and its resources) is defined in the Chart.yaml.
However, this name may be overriden to avoid conflict if more than one application use this chart.
*/}}
{{- define "spark-hs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark-hs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spark-hs.labels" -}}
helm.sh/chart: {{ include "spark-hs.chart" . }}
{{ include "spark-hs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark-hs.selectorLabels" -}}
app: {{ include "spark-hs.name" . }}
{{- end }}

{{- define "spark-hs.secret-env-variables" -}}
{{- if index .Values "secretName"  }}
{{-   $ext_secret_name :=  .Values.secretName  }}
{{- if index .Values.secret }}
{{- range $key, $val := .Values.secret }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $ext_secret_name }}
      key: {{ $val }}
{{- end}}
{{- end}}
{{- end}}
{{- end}}

