```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "my-app.fullname" . }}
  labels:
{{ include "my-app.labels" . | indent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: {{ include "my-app.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

|Default Objects - Release|
|  ---  |
| Release.Name |
| Releas Title |
| Release.Namespace |
| Release.Service |
| Release.Revision |
| Release.IsUpgrade |
| Release.IsInstall |

|Default Objects - Template|
|  ---  |
| Template.Name |
| Template BasePath |

|Default Objects - Root|
|  ---  |
| .Values |
| .Chart |

|Default Objects - Capabilities|
|  ---  |
| Capabilities.APIVersions |
| Capabilities APIVersions.Has $version |
| Capabilities.Kube.Version |
| Capabilities.Kube |
| Capabilities.Kube.Major |
| Capabilities.Kube.Minor |

|Default Objects - Files|
|  ---  |
| Files.Files |
| Files GetBytes |
| Files.Glob |
| Files.Lines |
| Files.AsSecrets |
| Files.AsConfig |
