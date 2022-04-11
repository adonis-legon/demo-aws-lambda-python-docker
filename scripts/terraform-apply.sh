DEPLOY_ENVIRONMENT=$1

cd ../terraform

terraform workspace select $DEPLOY_ENVIRONMENT

terraform apply -var-file="$DEPLOY_ENVIRONMENT.auto.tfvars"

cd ../scripts