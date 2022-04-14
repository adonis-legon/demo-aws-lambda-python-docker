# Demo Project for a simple AWS Lambda in Python packaged as Docker Image

## Setup Local Environment (for python running/debugging)

### On Windows

```console
$ # create virtual environment
$ python -m venv .venv
$ # activate virtual environment
$ source .venv/Scripts/activate
$ # upgrade pip
$ python -m pip install --upgrade pip
$ # install dependencies
$ pip install -r requirements.txt
```

**Important:** after adding/updating/removing dependencies to the local virtual environment, run this command to update dependencies file

```console
$ pip freeze > requirements.txt
```

## Docker Build Locally

```console
scripts$ . docker-build.sh <version>
scripts$ # example
scripts$ . docker-build.sh 1.0.0
```

## Docker Build Locally and Push to AWS ECR

**Important:** before running the push to AWS ECR feature, there must be a local/custom docker-env-[env].sh to have the correct AWS Account and User information

```console
scripts$ . docker-build.sh <version> <push-image> <aws-environment>
scripts$ # example
scripts$ . docker-build.sh 1.0.0 true dev
```

## Docker Start Locally

```console
scripts$ . docker-start.sh <version>
scripts$ # example
scripts$ . docker-start.sh 1.0.0
```

## Docker Function Invoke Locally (using Runtime Interfase Emulator or RIE)
```console
src/test$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d "@events/sample_api_event.json"
```

## Run Tests Locally (Unit and Integration)

```console
src/test$ pytest
```

## Setup Terraform

```console
terraform$ terraform init
```

## Review Infrastructure changes

```console
scripts$ . terraform-plan.sh <env>
```

## Apply Infrastructure changes

```console
scripts$ . terraform-apply.sh <env>
```

## E2E Test with Deployed Environment

```console
$ curl --request POST '<lambda_function_api_url>/sum' --header 'Content-Type: application/json' --data-raw '{"a": 1, "b": 2}'
```