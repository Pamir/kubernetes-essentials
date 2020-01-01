```bash
azure login
rg=myresourcegroup
location=eastus
blobStoreName=jdh3
containerName=helm
helmRepoName=jdhelm
az group create -n $rg -l $location
az storage account create \
-n $blobStoreName         \
-g $rg                    \
-l $location              \
--sku Standard_LRS        \
--kind BlobStorage        \
--access-tier Cool

export AZURE_STORAGE_ACCOUNT=$blobStoreName
export AZURE_STORAGE_KEY=$(az storage account keys list --resource-group $rg --account-name $blobStoreName | grep -m 1 value | awk -F'"' '{print $4}')

az storage container create \
--name helm                 \
--public-access blob

mkdir chart-test && cd chart-test
helm create myfirstchart
helm lint myfirstchart
helm package myfirstchart
helm repo index --url https://$blobStoreName.blob.core.windows.net/helm/ .

az storage blob upload --container-name $containerName --file index.yaml --name index.yaml
az storage blob upload --container-name $containerName --file *.tgz --name *.tgz
helm repo add repoName https://$blobStoreName.blob.core.windows.net/helm/
helm repo list
helm repo index --url https://$blobStoreName.blob.core.windows.net/helm/ --merge index.yaml .
helm serve
chrome https://$blobStoreName.blob.core.windows.net/helm/ 

```

References
- https://jessicadeen.com/how-to-create-a-public-helm-repo-using-azure-storage/
- https://github.com/hayorov/helm-gcs
- https://andrewlock.net/how-to-create-a-helm-chart-repository-using-amazon-s3/
- https://blog.minio.io/minio-as-helm-repository-for-your-kubernetes-cluster-9b2dcc771ee5