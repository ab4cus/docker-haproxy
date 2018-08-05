#!/bin/bash
#set -ex
#clear and pruge images
#docker system prune -a
# remover todas las imagenes
#docker rmi $(docker images -a -q)
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=haproxy
# version 
VERSION=1.8.13

docker build --no-cache -t $USERNAME/$IMAGE-$VERSION:latest .

sleep 5 

docker images -a
