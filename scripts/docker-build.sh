APP_NAME=demo-aws-lambda-python-docker
IMAGE_VERSION=${1:-1.0.0}
PUSH_IMAGE=${2:-false}
AWS_ENVIRONMENT=${3}

set -e

cd ..
source .venv/Scripts/activate

# run unit and integration tests
cd src/test
pytest
cd ../..

# build docker image
docker build -t $APP_NAME:$IMAGE_VERSION .

# push image to AWS ECR if selected
if [ "$PUSH_IMAGE" = true ]; then

    cd scripts
    . docker-env-$AWS_ENVIRONMENT.sh
    cd ..

    aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com

    docker tag $APP_NAME:$IMAGE_VERSION $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME:$IMAGE_VERSION
    docker push $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME:$IMAGE_VERSION

fi

cd scripts