FROM cdwlabs-docker.jfrog.io/protoc:3.5.1
MAINTAINER Brad Pinter <brad.pinter@cdw.com>

ENV GRPC_RELEASE v1.10.0

# Install protoc objc generator
###################################

RUN set -ex \
	&& apk --no-cache --update add --virtual .objc-builder \
  git \
  gcc \
  g++ \
  openssl \
  make \
	cmake \
  autoconf \
  automake \
  libtool \
  \
  && mkdir -p /usr/local/grpc \
  && git clone https://github.com/grpc/grpc.git /usr/local/grpc \
  \
  && cd /usr/local/grpc \
  && git checkout $GRPC_RELEASE \
  && git submodule update --init \
  \
  && cd /usr/local/grpc \
  && make grpc_objective_c_plugin \
  \
  && mkdir -p /opt/namely \
  && cp /usr/local/grpc/bins/opt/grpc_objective_c_plugin /opt/namely \
  && apk del .objc-builder \
	&& rm -rf /var/cache/apk/* \
  && rm -rf /usr/local/grpc \
  && rm -rf /usr/local/include

COPY script.sh /opt/namely/script.sh
ENTRYPOINT ["/opt/namely/script.sh"]
