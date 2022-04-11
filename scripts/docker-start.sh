APP_NAME=demo-aws-lambda-python-docker
IMAGE_VERSION=${1:-1.0.0}

# stop current container
docker rm $APP_NAME --force

# start new container
docker run -d --name $APP_NAME -p 9000:8080 $APP_NAME:$IMAGE_VERSION

# show contanier logs
docker logs $APP_NAME --follow