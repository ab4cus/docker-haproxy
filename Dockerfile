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
LABEL vendor=Ab4cus\ Tecnologia \
      net.ab4cus.is-beta="true" \
      net.ab4cus.is-production="false" \
      net.ab4cus.version="0.0.1-beta" \
      net.ab4cus.release-date="2018-06-08"

ENV HAPROXY_HOME /opt/haproxy
ENV HAPROXY_USER haproxy
ENV HAPROXY_GROUP haproxy

RUN mkdir -p $HAPROXY_HOME
RUN groupadd -r $HAPROXY_GROUP
RUN useradd -r -g $HAPROXY_GROUP -d $HAPROXY_HOME -s /sbin/nologin $HAPROXY_USER
RUN chown -R $HAPROXY_USER:$HAPROXY_GROUP $HAPROXY_HOME
RUN mkdir -p /run/haproxy

RUN apt-get update \
#	&& apt-get upgrade \
	&& apt-get install -y software-properties-common iputils-ping vim curl\
	&& add-apt-repository ppa:vbernat/haproxy-1.8 \
	&& apt-get update \
	&& apt-get install -y haproxy=1.8.\*  rsyslog \
	&& sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/haproxy/

COPY haproxy.cfg.prod /etc/haproxy/
COPY haproxy.cfg.dev /etc/haproxy/
COPY haproxy.cfg.test /etc/haproxy/
RUN cp haproxy.cfg.prod haproxy.cfg

ENV PATH=/opt/java/bin:$PATH

# Define working directory.
WORKDIR /etc/haproxy

# traffic ports
EXPOSE 80 443

# administrative ports
# 82: TCP stats socket
# 88: HTTP stats page
EXPOSE 81 82 88

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# Define default command.

CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
