REPO_NAME="microservice-project"
AWS_REGION="us-east-1"
ECR_REGISTRY="654421006949.dkr.ecr.us-east-1.amazonaws.com"

aws ecr describe-repositories \
    --repository-name ${REPO_NAME} \
    --region ${AWS_REGION} || \
aws ecr create-repository \
    --repository-name ${REPO_NAME} \
    --image-tag-mutability IMMUTABLE \
    --region ${AWS_REGION} \
    --image-scanning-configuration scanOnPush=false

. ./jenkins/maven_package.sh
. ./jenkins/prepare_tags.sh
. ./jenkins/ecr_build_images.sh
. ./jenkins/push_images.sh

sonra terminalde kurulacak

aws s3api create-bucket \
    --bucket harun-helm-repo \
    --region us-east-1

aws s3api put-object --bucket harun-helm-repo --key stable/myapp/

helm plugin install https://github.com/hypnoglow/helm-s3.git

aynısını sudo su - jenkins için de kurmalısın

helm s3 init s3://harun-helm-repo/stable/myapp/

helm create petclinic-chart

helm repo add stable-myapp s3://harun-helm-repo/stable/myapp/

helm repo ls

helm package petclinic-chart

helm s3 push ./petclinic-chart-0.1.0.tgz stable-myapp

helm search repo -l

helm repo update

helm upgrade --install my-app-release stable-myapp/my-app --version 0.1.1 --namespace dev











envsubst < k8s/petclinic-chart/values_template.yaml > k8s/petclinic-chart/values.yaml