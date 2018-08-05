#!/bin/bash
#set -ex
#docker rm $(docker ps -a -f status=exited -q)
# run docker
# Local
docker run --name=web-haproxy \
	-m 512MB \
	--hostname=app.e4cash.local \
	-p 80:80 \
	-p 443:443 \
	-p 81:81 \
	-p 82:82 \
	-p 90:90 \
	-d e4cash/haproxy-1.8.13:latest 

# test configuration
#docker run -it --rm --name haproxy-syntax-check e4cash/haproxy-1.8.13:latest haproxy -c -f /opt/haproxy/haproxy.cfg
#docker run -it --rm --name haproxy-syntax-check e4cash/haproxy-1.8.13:latest haproxy -v

#docker run -d -it e4cash/haproxy-1.8.13:latest bash
#docker run -d e4cash/haproxy-1.8.13:latest haproxy -f /opt/haproxy/haproxy.cfg
#docker run -it --name haproxy10 -p 80:80 -d e4cash/haproxy-1.8.13:latest bash
#docker run -it --name haproxy10 -d e4cash/haproxy-1.8.13:latest bash

# Testing
#docker run  --name=web-haproxy \
#	-m 1.5GB \
#	--network-alias=haproxy \
#	--hostname=app.e4cash.local \
#	--add-host=app.core.priv.e4-cash.net:10.132.148.63 \
#	-p 80:80 \
#	-p 443:443 \
#	-p 81:81 \
#	-p 82:82 \
#	-p 90:90 \
#	-v /opt/haproxy:/etc/haproxy \
#	-d e4cash/haproxy-1.6.3:latest

sleep 5

docker ps -a
