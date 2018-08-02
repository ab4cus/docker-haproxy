set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=proxy
# version HAproxy
VERSION=1.8

docker build --tag=$IMAGE-haproxy-$VERSION -t $USERNAME/$IMAGE-haproxy-$VERSION:latest .

