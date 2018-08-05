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

ENV HAPROXY_MAJOR 1.8
ENV HAPROXY_VERSION 1.8.13
ENV HAPROXY_SHA256 2bf5dafbb5f1530c0e67ab63666565de948591f8e0ee2a1d3c84c45e738220f1
ENV HAPROXY_HOME /opt/haproxy
ENV HAPROXY_USER haproxy
ENV HAPROXY_GROUP haproxy

RUN mkdir -p $HAPROXY_HOME
RUN groupadd -r $HAPROXY_GROUP
RUN useradd -r -g $HAPROXY_GROUP -d $HAPROXY_HOME -s /sbin/nologin $HAPROXY_USER
RUN chown -R $HAPROXY_USER:$HAPROXY_GROUP $HAPROXY_HOME
RUN mkdir -p /run/haproxy

# see https://sources.debian.net/src/haproxy/jessie/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN set -x \
	\
	&& savedAptMark="$(apt-mark showmanual)" \
	&& apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		gcc \
		libc6-dev \
		liblua5.3-dev \
		libpcre3-dev \
		libssl-dev \
		make \
		wget \
		zlib1g-dev \
		rsyslog \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& wget -O haproxy.tar.gz "https://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" \
	&& echo "$HAPROXY_SHA256 *haproxy.tar.gz" | sha256sum -c \
	&& mkdir -p /usr/src/haproxy \
	&& tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
	&& rm haproxy.tar.gz \
	\
	&& makeOpts=' \
		TARGET=linux2628 \
		USE_LUA=1 LUA_INC=/usr/include/lua5.3 \
		USE_OPENSSL=1 \
		USE_PCRE=1 PCREDIR= \
		USE_ZLIB=1 \
	' \
	&& make -C /usr/src/haproxy -j "$(nproc)" all $makeOpts \
	&& make -C /usr/src/haproxy install-bin $makeOpts \
	\
	&& mkdir -p $HAPROXY_HOME \
	&& cp -R /usr/src/haproxy/examples/errorfiles $HAPROXY_HOME/errors \
	&& rm -rf /usr/src/haproxy \
	\
	&& apt-mark auto '.*' > /dev/null \
	&& { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
	&& find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

COPY haproxy.cfg $HAPROXY_HOME/haproxy.cfg

# Define mountable directories.
#VOLUME ["/haproxy-override"]

# Define working directory.
WORKDIR $HAPROXY_HOME

# traffic ports
EXPOSE 80 443

# administrative ports
# 82: TCP stats socket
# 88: HTTP stats page
EXPOSE 81 82 88

COPY docker-entrypoint.sh /

RUN chmod 555 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# Define default command.

CMD ["haproxy", "-f", "/opt/haproxy/haproxy.cfg"]
#CMD ["haproxy", "-v"]
