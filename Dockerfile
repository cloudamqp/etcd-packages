FROM ubuntu:24.04 AS pkg-builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y ruby rpm binutils curl \
    && gem install fpm
WORKDIR /tmp/pkg

# arguments
ARG etcd_version=v3.5.16
ARG TARGETOS
ARG download_url=https://github.com/etcd-io/etcd/releases/download
ARG pkg_revision=1

# AMD64
ARG arch=amd64
RUN mkdir -p tmp/etcd
RUN mkdir -p pkg/usr/bin
# download and unpack etcd
RUN curl -L ${download_url}/${etcd_version}/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz -o tmp/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz
RUN tar xzvf tmp/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz -C tmp/etcd/ --strip-components=1
RUN cp tmp/etcd/etcd* pkg/usr/bin/
COPY etcd.service pkg/etc/systemd/system/
# create deb package
RUN fpm -s dir -t deb -n etcd -v ${etcd_version} --iteration ${pkg_revision} -a ${arch} \
  --url https://etcd.io --maintainer "84codes <contact@84codes.com>" \
  --description "A distributed, reliable key-value store" \
  --deb-systemd etcd.service \
  --license "Apache 2.0" --chdir pkg .

# ARM64
ARG arch=arm64
RUN rm -rf tmp/etcd/*
RUN rm -rf pkg/usr/bin/*
# download and unpack etcd
RUN curl -L ${download_url}/${etcd_version}/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz -o tmp/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz
RUN tar xzvf tmp/etcd-${etcd_version}-${TARGETOS}-${arch}.tar.gz -C tmp/etcd/ --strip-components=1
RUN cp tmp/etcd/etcd* pkg/usr/bin/
COPY etcd.service pkg/etc/systemd/system/
# create deb package
RUN fpm -s dir -t deb -n etcd -v ${etcd_version} --iteration ${pkg_revision} -a ${arch} \
  --url https://etcd.io --maintainer "84codes <contact@84codes.com>" \
  --description "A distributed, reliable key-value store" \
  --deb-systemd etcd.service \
  --license "Apache 2.0" --chdir pkg .

# put .deb files in a scratch image for exporting
FROM scratch
COPY --from=pkg-builder /tmp/pkg/*.deb /tmp/pkg/*.rpm .