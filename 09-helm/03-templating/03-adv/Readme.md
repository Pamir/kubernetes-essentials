#### NFS Provisioner Chart
##### conditions
```yaml
   spec:
      # NOTE: This is 10 seconds longer than the default nfs-provisioner --grace-period value of 90sec
      terminationGracePeriodSeconds: 100
      serviceAccountName: {{ if .Values.rbac.create }}{{ template "nfs-provisioner.fullname" . }}{{ else }}{{ .Values.rbac.serviceAccountName | quote }}{{ end }}
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
```
##### Loops
```yaml
```


