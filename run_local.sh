#!/usr/bin/env bash

# script to start redis container, build image if not exists and start container with app
# usage ./run_local.sh <version>

redis_address="redis://redis:6379"

app_version=$(cat ./version)
app_version="${app_version:-0.1}"

echo app_version="$app_version"

# start redis if not running
# restart redis to clear state
[ "$(docker ps -q -f name=redis1)" ] && docker rm -f redis1
docker run -d --name redis1 -p 6379:6379 redis


# build image if not exists
if [ "$(docker images -q node_app:"$app_version" 2> /dev/null)" == "" ]; then
docker build -t node_app:"$app_version" .
fi

# uncomment if you want to push image to docker hub. (don't forget to run command: docker login)
# hub_user="rzaytsev"
# docker tag node_app:"$app_version" "$hub_user"/pageview_counter:"$app_version"
# docker push  "$hub_user"/pageview_counter:"$app_version"


# stop all containers with a name node_app
docker ps -a | awk '{ print $1,$2 }' | grep node_app | awk '{print $1 }' | xargs -I {} docker rm -f {}

# run container
docker run -d --name node_app1 -e REDIS_ADDRESS="$redis_address" --link redis1:redis -p 8888:8888 node_app:"$app_version"


# if you want to test scalability you can run more containers on diffrent ports
docker run -d --name node_app2 -e REDIS_ADDRESS="$redis_address" --link redis1:redis -p 8889:8888 node_app:"$app_version"
