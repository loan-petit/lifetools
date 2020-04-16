#!/bin/bash
set -euo pipefail

SOURCE_DIR=$(dirname "${BASH_SOURCE[0]}")
SOURCE_PATH=$(readlink -e $SOURCE_DIR)

SECRETS_DIR="$SOURCE_PATH/.secrets"

function usage() {
  echo "Usage: $0 SERVICE_TO_BUILD..."
  exit 1
}

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

SERVICES_TO_BUILD=()

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -h | --help)
    usage
    ;;
  *)                   # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift              # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Build every services if none was specified
if [ ${#POSITIONAL[@]} -eq 0 ]; then
  POSITIONAL=(
    "flutter"
    "prisma"
  )
fi

for service in "${POSITIONAL[@]}"; do
  if [ "$service" == "flutter" ]; then
    # Build Docker image for 'flutter' service.
    docker build --no-cache --tag lifetools:flutter \
      --build-arg FLUTTER_VERSION=1.17.0-dev.3.1 \
      $SOURCE_DIR/../flutter

    # Tag the builded image
    FLUTTER_IMAGE_ID=$(docker image inspect lifetools:flutter --format='{{ .Id }}')
    docker tag $FLUTTER_IMAGE_ID petitloan/lifetools:flutter
  fi

  if [ "$service" == "prisma" ]; then
    # Build Docker image for 'prisma' service.
    DOCKER_BUILDKIT=1 docker build --no-cache --tag lifetools:prisma \
      --build-arg POSTGRES_HOST=www.lifetools.loanpetit.com \
      --secret id=POSTGRES_PASSWORD,src=$SECRETS_DIR/POSTGRES_PASSWORD.txt \
      --secret id=JWT_SECRET,src=$SECRETS_DIR/JWT_SECRET.txt \
      $SOURCE_DIR/../prisma

    # Tag the builded image
    PRISMA_IMAGE_ID=$(docker image inspect lifetools:prisma --format='{{ .Id }}')
    docker tag $PRISMA_IMAGE_ID petitloan/lifetools:prisma
  fi
done

# Push builded images to Docker Hub 'petitloan/lifetools' repository
docker push petitloan/lifetools
