#!/usr/bin/env bash

# config
read -p "Mongodb data directory on the host system [~/_LODE/datadir]: " datadir
datadir=${datadir:-~/_LODE/datadir}
read -p "Local folder share to mount as LODE3 distribution contents [~/_LODE/public]: " public
public=${public:-~/_LODE/public}

# stop and remove containers
docker stop lode3nodeapp lode3mongo
docker rm lode3nodeapp lode3mongo

# clean
rm -R "$datadir/*"
rm -R "$public/*"

# public
cp -R public/* "$public"

# mongodb
docker run --name lode3mongo -v "$datadir:/data/db" -d -p 27017:27017 mongo:3.3

# lode3ws
docker build --rm=true --file=docker/Dockerfile -t unitn.it/lode3node .
#docker run -v "$public:/usr/src/app/public" -d --name lode3nodeapp --link lode3mongo -p 3000:3000 unitn.it/lode3node
docker run -v "$public:/usr/src/app/public"  --name lode3nodeapp --link lode3mongo -p 3000:3000 -i -t unitn.it/lode3node

#
#set -- "$DOCKER_HOST"
#IFS=":"; declare -a Array=($*)
#read -p "Done. Press enter to continue."
#open "http:${Array[1]}:3000/lecture.html?content=test"
#echo "Application url: http:${Array[1]}:3000/lecture.html?content=test"
