# etcd DEB/RPM packages
Multi-architecture (amd64 and arm64) DEB/RPM package builder for [etcd](https://etcd.io/). The images are built using [GitHub actions](/.github/workflows/docker.yml).

The packages are published at https://packagecloud.io/84codes/etcd

## Install

curl -fsSL https://packagecloud.io/84codes/etcd/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/84codes_etcd.gpg
. /etc/os-release
echo "deb https://packagecloud.io/84codes/etcd/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/84codes_etcd.list
apt-get update
apt-get install etcd