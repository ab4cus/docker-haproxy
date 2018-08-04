set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=haproxy
# version HAproxy
VERSION=1.8.13

docker build -t $USERNAME/$IMAGE-$VERSION:latest .

sleep 5 

docker images