FROM cdwlabs-docker.jfrog.io/protoc:3.5.1
MAINTAINER Brad Pinter <brad.pinter@cdw.com>

ENV GO_VERSION 1.10.1
ENV GO_SRC_URL http://golang.org/dl/go$GO_VERSION.src.tar.gz
ENV GO_SRC_SHA1 f3de49289405fda5fd1483a8fe6bd2fa5469e005fd567df64485c4fa000c7f24

ENV GO_BOOTSTRAP_VERSION 1.4.3
ENV GO_BOOTSTRAP_URL http://storage.googleapis.com/golang/go$GO_BOOTSTRAP_VERSION.src.tar.gz
ENV GO_BOOTSTRAP_SHA1 486db10dc571a55c8d795365070f66d343458c48

ENV CGO_ENABLED 0

# Install protoc go generator
###################################
RUN mkdir -p /go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN set -ex \
	&& apk --no-cache add --virtual .scm \
  bash \
  musl-dev \
  git \
  gcc \
	openssl \
  binutils \
  build-base \
	&& mkdir -p /usr/local/bootstrap \
	&& wget -q "$GO_BOOTSTRAP_URL" -O golang.tar.gz \
	&& echo "$GO_BOOTSTRAP_SHA1  golang.tar.gz" | sha1sum -c - \
	&& tar -C /usr/local/bootstrap -xzf golang.tar.gz \
	&& rm golang.tar.gz \
	&& cd /usr/local/bootstrap/go/src \
	&& ./make.bash \
	&& export GOROOT_BOOTSTRAP=/usr/local/bootstrap/go \
	\
	&& wget -q "$GO_SRC_URL" -O golang.tar.gz \
	&& echo "$GO_SRC_SHA1  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz \
	&& cd /usr/local/go/src \
	&& ./make.bash \
  \
  && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
  && chmod -R 777 "$GOPATH" \
	\
	&& go get -u github.com/golang/dep/cmd/dep \
	&& go get -a github.com/golang/protobuf/protoc-gen-go \
	&& go get github.com/micro/protoc-gen-micro \
	\
  && apk del .scm \
	&& rm -rf /usr/local/bootstrap \
  && rm -rf /var/cache/apk/* \
  && rm -rf /usr/local/go \
  && rm -rf "$GOPATH/src"

COPY script.sh /opt/namely/script.sh
ENTRYPOINT ["/opt/namely/script.sh"]
