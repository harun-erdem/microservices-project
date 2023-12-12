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