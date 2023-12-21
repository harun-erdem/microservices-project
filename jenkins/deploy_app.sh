envsubst < k8s/petclinic-chart/values_template.yaml > k8s/petclinic-chart/values.yaml
sed -i s/HELM_VERSION/${BUILD_NUMBER}/ k8s/petclinic-chart/Chart.yaml
AWS_REGION=${AWS_REGION} helm repo add stable-myapp s3://harun-helm-repo/stable/myapp/ || echo 'Helm repo is already exist'
AWS_REGION=${AWS_REGION} helm repo update
helm package k8s/petclinic-chart
AWS_REGION=${AWS_REGION} helm s3 push --force ./petclinic-chart-${BUILD_NUMBER}.tgz stable-myapp
kubectl create ns petclinic || echo 'namespace is already exist'
kubectl delete secret regcred --namespace petclinic || \
kubectl create secret generic regcred --namespace petclinic \
    --from-file=.dockerconfigjson=var/lib/jenkins/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
AWS_REGION=${AWS_REGION} helm repo update
AWS_REGION=${AWS_REGION} helm upgrade --install my-app-release stable-myapp/petclinic-chart --version ${BUILD_NUMBER} --namespace petclinic