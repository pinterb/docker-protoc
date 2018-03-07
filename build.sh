#!/usr/bin/env bash

set -e

echo "Building Docker containers"

declare -a IMAGES
DIRS=( $(basename -s $(find . ! -path . -type d -not -path '*/\.*') ) )

REGISTRY='cdwlabs-docker.jfrog.io'
BASE_IMAGE='protoc'
#TAG=$(git rev-parse --short HEAD)
TAG='3.5.1'

buildAll () {
  docker build -t $REGISTRY/$BASE_IMAGE:$TAG .
  for i in ${!DIRS[@]};
  do
    echo
    echo "Building ${DIRS[$i]}... "
    IMAGE=$REGISTRY/$BASE_IMAGE-${DIRS[$i]}:$TAG
    docker build -t $IMAGE ./${DIRS[$i]}
    IMAGES+=( $IMAGE )
  done
}

#Read from args
while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -t|--tag)
      TAG=$2
      shift
      ;;
    *)
      ;;
  esac
  shift
done

buildAll

echo "Done!"
