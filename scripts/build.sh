APP_NAME=demo-aws-lambda-python-docker
IMAGE_VERSION=${1:-1.0.0}

set -e

cd ..
source .venv/Scripts/activate

# run unit and integration tests
cd src/test
pytest
cd ../..

# build docker image
docker build -t $APP_NAME:$IMAGE_VERSION .

cd scripts