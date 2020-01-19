#!/bin/bash

set -e

SOURCE_DIR=$( dirname "${BASH_SOURCE[0]}")

cd $SOURCE_DIR/..

# Name and build local images
docker build -t petitloan/lifetools:nginx --build-arg APP_ENV=prod ./nginx/
docker build -t petitloan/lifetools:prisma ./prisma/
docker build -t petitloan/lifetools:flutter --build-arg FLUTTER_VERSION=v1.14.0 ./flutter/

# Push images to the Docker Hub repository.
docker push petitloan/lifetools:nginx
docker push petitloan/lifetools:prisma
docker push petitloan/lifetools:flutter
