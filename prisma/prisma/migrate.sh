#!/bin/bash

set -e

SOURCE_DIR=$( dirname "${BASH_SOURCE[0]}")

MIGRATOR_TAG='lifetools_migrator'

DB_CONTAINER_TAG='lifetools_postgres'

NETWORK_NAME='lifetools_default'

cd $SOURCE_DIR

export $(grep '^POSTGRES_URL' ../docker-compose.env | xargs)

[ "$(docker inspect -f '{{.State.Running}}' $DB_CONTAINER_TAG)" != "true" ] \
  && echo "The $DB_CONTAINER_TAG container isn't running. Please start it." \
  && exit 1

docker build -f migrate.dockerfile -t $MIGRATOR_TAG .

PRISMA_COMMANDS="prisma2 lift save --name '' && prisma2 lift up"

docker run --rm --network=$NETWORK_NAME -e POSTGRES_URL \
  -v "$(pwd)/migrations":'/prisma/migrations/' \
  $MIGRATOR_TAG /bin/bash -c "$PRISMA_COMMANDS"
