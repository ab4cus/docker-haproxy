docker stop web-haproxy
docker rm $(docker ps -a -f status=exited -f status=created -q)
docker ps
