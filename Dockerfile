FROM alpine:3.6
MAINTAINER Brad Pinter <brad.pinter@cdw.com>

ENV GIT_CLONE_DIR="/gitclones"
ENV GOOGLEAPIS_DIR="$GIT_CLONE_DIR/googleapis"
ENV GOOGLEAPIS_GIT_URL="https://github.com/googleapis/googleapis"

# Install Protoc
################
RUN set -ex \
	&& apk --update --no-cache add \
  bash \
  git \
	&& apk --no-cache add --virtual .pb-build \
  make \
	cmake \
  autoconf \
  automake \
  curl \
  tar \
  libtool \
	g++ \
  \
	&& mkdir -p /tmp/protobufs \
	&& cd /tmp/protobufs \
	&& curl -o protobufs.tar.gz -L https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-cpp-3.5.1.tar.gz \
	&& mkdir -p protobuf \
	&& tar -zxvf protobufs.tar.gz -C /tmp/protobufs/protobuf --strip-components=1 \
	&& cd protobuf \
	&& ./autogen.sh \
	&& ./configure --prefix=/usr \
	&& make \
	&& make install \
  && cd \
	&& rm -rf /tmp/protobufs/ \
  && rm -rf /tmp/protobufs.tar.gz \
	&& apk --no-cache add libstdc++ \
	&& apk del .pb-build \
	&& rm -rf /var/cache/apk/* \
	&& mkdir /defs

# To generate a protobuf descriptor set for a gRPC service, we need to clone
# the googleapis repository.
################
RUN set -ex \
	&& mkdir "$GIT_CLONE_DIR" \
  && git clone "$GOOGLEAPIS_GIT_URL" "$GIT_CLONE_DIR/googleapis"

# Setup directories for the volumes that should be used
WORKDIR /defs
