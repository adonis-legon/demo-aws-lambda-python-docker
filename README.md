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
scripts$ . build.sh <version>
```

## Docker Start Locally

```console
scripts$ . start.sh <version>
```

## Docker Function Invoke Locally (using Runtime Interfase Emulator or RIE)
```console
src/test$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d "@events/sample_api_event.json"
```

## Run Tests Locally (Unit and Integration)

```console
src/test$ pytest
```