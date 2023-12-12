REPO_NAME="microservice-project"
AWS_REGION="us-east-1"
aws ecr describe-repositories \
    --repository-name ${REPO_NAME} \
    --region ${AWS_REGION} || \
aws ecr create-repository \
    --repository-name ${REPO_NAME} \
    --image-tag-mutability IMMUTABLE \
    --region ${AWS_REGION} \
    --image-scanning-configuration scanOnPush=false



# aws ecr delete-repository \
#     --repository-name ${REPO_NAME} \
#     --region ${AWS_REGION} \
#     --force