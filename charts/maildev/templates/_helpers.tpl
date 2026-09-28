{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "maildev.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "maildev.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "maildev.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "maildev.labels" -}}
helm.sh/chart: {{ include "maildev.chart" . }}
{{ include "maildev.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "maildev.selectorLabels" -}}
app.kubernetes.io/name: {{ include "maildev.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Health endpoint of the web interface: /api/healthz since MailDev 3.0, /healthz before.
Non-semver tags (e.g. latest) are considered >= 3.0.
*/}}
{{- define "maildev.probePath" -}}
{{- if .Values.probes.path -}}
{{- .Values.probes.path -}}
{{- else -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString | trimPrefix "v" -}}
{{- $semver := regexFind "^[0-9]+\\.[0-9]+\\.[0-9]+" $tag -}}
{{- if and $semver (semverCompare "<3.0.0" $semver) -}}
/healthz
{{- else -}}
/api/healthz
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "maildev.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "maildev.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
