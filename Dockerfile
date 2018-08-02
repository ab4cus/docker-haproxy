# e4Cash DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for HAProxy 
# 
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -t e4cash/haproxy:1.8.0.Final . 
#
# Pull base image
# ---------------
FROM ubuntu:16.04

# Maintainer
# ----------
LABEL maintainer="jose.schmucke@ab4cus.com"
MAINTAINER Jose A. Schmucke <jose.schmucke@ab4cus.com>

RUN apt-get update \
#	&& apt-get upgrade \
	&& apt-get install -y software-properties-common iputils-ping \
	&& apt-get install -y haproxy 
#	sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
#	\ && rm -rf /var/lib/apt/lists/*


RUN sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy
RUN haproxy -v
RUN mkdir -p /run/haproxy/

# Add files.
ADD hosts /tmp
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD start.sh /haproxy-start
RUN more /tmp/hosts

ENV PATH=/opt/java/bin:$PATH
RUN cat /tmp/hosts >> /etc/hosts
RUN echo  "10.132.148.63 app.core.priv.e4-cash.net app.core.priv" >> /etc/hosts
RUN more /etc/hosts

# Test config
#RUN haproxy -f /etc/haproxy/haproxy.cfg -c

#COPY docker-entrypoint.sh /

# Define mountable directories.
VOLUME ["/haproxy-override"]

# Define working directory.
WORKDIR /etc/haproxy

# traffic ports
EXPOSE 80 443

# administrative ports
# 82: TCP stats socket
# 88: HTTP stats page
EXPOSE 81 82 88

#ENTRYPOINT ["/docker-entrypoint.sh"]

#CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
# Define default command.
CMD ["bash", "/haproxy-start"]