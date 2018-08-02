set -ex
# run docker
# docker run -t -i  e4cash/proxy-haproxy-1.8:latest
docker run --name=haproxy1.8-core -m 1.5GB --add-host=app.core.priv.e4-cash.net:10.132.148.63 -p 80:80 -p 443:443 -p 9990:9990 -d e4cash/proxy-haproxy-1.8:latest 

docker ps
