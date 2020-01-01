```bash
mkdir -p ~/dev/tools_data
cd ~/dev/tools_data
git clone https://github.com/helm/charts.git
mkdir -p ~/dev/projects/charts
cd ~/dev/projects/charts
helm create my-app
cd my-app
ls -lart
helm install --name my-app . --namespace myapp -f values.yaml
cd charts
mkdir mysql
cd mysql
cp ~/dev/tools_data/charts/stable/mysql/Chart.yaml .
mkdir templates
cp ~/projects/helm2-workshop/02-charts/02-umbrella/deployment.yaml templates/
cd ~/dev/projects/charts/my-app
helm upgrade my-app . -f values.yaml 
```
References
-  https://codefresh.io/docs/docs/new-helm/helm-best-practices/
