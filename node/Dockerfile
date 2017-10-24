FROM cdwlabs-docker.jfrog.io/protoc
MAINTAINER Brad Pinter <brad.pinter@cdw.com>

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.7.0
ENV GRPC_RELEASE v1.6.7

# Install protoc node.js generator
###################################
##	&& apk add --no-cache \
  ##	    libstdc++ \

RUN set -ex \
	&& apk --no-cache --update add --virtual .node-builder \
  libstdc++ \
  binutils-gold \
  curl \
  git \
  gcc \
  g++ \
  gnupg \
  libgcc \
  linux-headers \
  openssl \
  make \
	cmake \
  autoconf \
  automake \
  libtool \
  python \
  # gpg keys listed at https://github.com/nodejs/node#release-team
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
  \
  && mkdir -p /usr/local/grpc \
  && git clone https://github.com/grpc/grpc.git /usr/local/grpc \
  \
  && cd /usr/local/grpc \
  && git checkout $GRPC_RELEASE \
  && git submodule update --init \
  \
  && cd /usr/local/grpc \
  && make grpc_node_plugin \
  \
  && mkdir -p /opt/namely \
  && cp /usr/local/grpc/bins/opt/grpc_node_plugin /opt/namely \
  && apk del .node-builder \
	&& rm -rf /var/cache/apk/* \
  && rm -rf /usr/local/grpc \
  && rm -rf /usr/local/include

COPY script.sh /opt/namely/script.sh
ENTRYPOINT ["/opt/namely/script.sh"]
