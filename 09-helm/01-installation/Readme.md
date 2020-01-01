#### Linux
```bash
kubectl config current-context
kubectl cluster-info
```

#### macos
```bash
mkdir -p ~/dev/tools/helm
cd ~/dev/tools/helm
curl -o helm.tar.gz https://get.helm.sh/helm-v2.16.1-darwin-amd64.tar.gz
tar -zxf helm.tar.gz
echo 'export PATH=$PATH:'$PWD'/darwin-amd64'
echo 'export PATH=$PATH:'$PWD'/darwin-amd64' >> ~/.bashrc
source ~/.bashrc
helm version
```

#### windows
```powershell
choco install kubernetes-helm --version 2.16.1
helm version
```

Output of the command
```
Client: &version.Version{SemVer:"v2.16.1", GitCommit:"bbdfe5e7803a12bbdf97e94cd847859890cf4050", GitTreeState:"clean"}
```

#### Tiller installation
```bash
kubectl apply -f 01-single-k8s/helm-rbac.yaml
helm init --history-max 200 --service-account tiller --node-selectors "beta.kubernetes.io/os=linux"
```

#### Tiller installation with TLS
```bash
openssl genrsa -out ./ca.key.pem 4096
openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca
openssl genrsa -out ./tiller.key.pem 4096
openssl genrsa -out ./helm.key.pem 4096
openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem
openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 365
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in helm.csr.pem -out helm.cert.pem  -days 365
```
```
# The CA. Make sure the key is kept secret.
ca.cert.pem
ca.key.pem
# The Helm client files
helm.cert.pem
helm.key.pem
# The Tiller server files.
tiller.cert.pem
tiller.key.pem
```

```bash
helm init --dry-run --debug --tiller-tls --tiller-tls-cert ./tiller.cert.pem  \
--tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem

helm init --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem \
--tiller-tls-verify --tls-ca-cert ca.cert.pem --service-account tiller

helm ls --tls --tls-ca-cert ca.cert.pem \
--tls-cert helm.cert.pem --tls-key helm.key.pem
cp ca.cert.pem ~/.helm/ca.pem
cp helm.cert.pem ~/.helm/cert.pem
cp helm.key.pem ~/.helm/key.pem
```


#### Notes
- https://github.com/denji/golang-tls
- https://medium.com/google-cloud/install-secure-helm-in-gke-254d520061f7