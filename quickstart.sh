#!/usr/bin/env bash

# Check and pull image
function checkAndPull {
    echo "Check $1 image"
    if [[ -z "$(docker images -q $1 2> /dev/null)" ]]; then
        echo "Pull $1 image"
        docker pull $1
    else
        echo "$1 image is updated"
    fi
}

# Check and delete container
function checkAndDeleteContainer {
    echo "Check $1 container"
    status=`docker inspect --format='{{.State.Status}}' $1 2> /dev/null`
    if [ -z "$status" ]; then
        echo "The $1 container is not present"
    else
        echo "The $1 container status is $status"
        if [ "$status" = 'running' ]; then
            echo "Stopping..."
            docker stop $1
        fi
        echo "Removing..."
        docker rm $1
    fi
}

# Check and delete data directory
function checkAndDeleteDirectory {
    if [[ (-d $1) && ("$(ls -A $1)") ]]; then
        read -p "The $1 directory is not empty. Do you want to erase data? [no]: " res
        res=`echo "$res" | tr '[:upper:]' '[:lower:]'`
        if [[ ($res = "y") || ($res = "yes") ]]; then
            echo "Removing..."
            rm -R "$1"
            mkdir "$1"
        fi
    fi
}

# Check and pull images
checkAndPull 'mongo:3.3'
checkAndPull 'node:7.0.0'

# Delete containers
checkAndDeleteContainer 'lode3mongo'
checkAndDeleteContainer 'lode3nodeapp'

# Setup
read -p "Mongodb data directory on the host system [~/_LODE3/datadir]: " datadir
datadir=${datadir:-~/_LODE3/datadir}
checkAndDeleteDirectory "$datadir"
read -p "Local folder share to mount as LODE3 distribution contents [~/_LODE3/lectures]: " lectures
lectures=${lectures:-~/_LODE3/lectures}
checkAndDeleteDirectory "$lectures"

# Node application to deploy
#cp -R public/* $public

# mongodb
docker run --name lode3mongo -v "$datadir:/data/db" -d -p 27017:27017 mongo:3.3

# lode3ws
docker build --rm=true --file=docker/Dockerfile -t unitn.it/lode3node .
#docker run -v "$public:/usr/src/app/public" -d --name lode3nodeapp --link lode3mongo -p 3000:3000 unitn.it/lode3node
docker run -v "$(pwd)/public:/usr/src/app/public" -v "$lectures:/usr/src/app/public/lectures" --name lode3nodeapp --link lode3mongo -p 3000:3000 -i -t unitn.it/lode3node
