# etcd DEB/RPM packages
Multi-architecture (amd64 and arm64) DEB/RPM package builder for [etcd](https://etcd.io/). The images are built using [GitHub actions](/.github/workflows/docker.yml).

The packages are published at https://packagecloud.io/cloudamqp/etcd

## Install
```sh
curl -fsSL https://packagecloud.io/cloudamqp/etcd/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/cloudamqp_etcd.gpg
. /etc/os-release
echo "deb https://packagecloud.io/cloudamqp/etcd/any any main" | sudo tee /etc/apt/sources.list.d/cloudamqp_etcd.list
apt-get update
apt-get install etcd
```
