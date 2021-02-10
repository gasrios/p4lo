#!/usr/bin/env sh

set -eux

export PYTHON_VERSION=3.9.1

while [ "$#" -gt 0 ]
do
  case "$1" in
    "--python-version")
      shift
      PYTHON_VERSION="$1"
    ;;
    *)
      echo "Unrecognized parameter \"$1\". Usage: compile-python.sh [--python-version PYTHON_VERSION]"
      exit 1
    ;;
  esac
  shift
done

export DISTRO=$(egrep '^ID=' /etc/os-release | sed 's/^ID="\?\([^"]*\)"\?/\1/')
export DISTRO_VERSION=$(egrep '^VERSION_ID=' /etc/os-release | sed 's/^VERSION_ID="\?\([^"]*\)"\?/\1/')

#
# Distribution dependent setup goes in this function
#
distro_dependent_setup() {

  # Install packages needed to compile Python
  case "${DISTRO}" in
  alpine)
    apk update
    apk upgrade
    apk add wget make g++ libffi-dev zlib-dev openssl-dev rust cargo
  ;;
  amzn)
    yum update -y
    yum install -y wget tar gzip bzip2 make gcc libffi-devel zlib-devel openssl-devel
  ;;
  centos|fedora)
    dnf update -y
    dnf install -y wget tar gzip bzip2 make gcc findutils libffi-devel zlib-devel openssl-devel
  ;;
  debian|ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
    apt install --assume-yes wget bzip2 make gcc libffi-dev zlib1g-dev libssl-dev
  ;;
  *)
    echo "Unsupported distro ${DISTRO}"
    exit 1
  ;;
  esac

}

#
# Everything below this point MUST be distro agnostic
#
if [ ! -f "repository/${DISTRO}-${DISTRO_VERSION}-${PYTHON_VERSION}.tbz" ]
then
  distro_dependent_setup

  export BASE_DIR=$(pwd)

  export TARGET_DIR=/opt/python-${PYTHON_VERSION}
  rm -rf ${TARGET_DIR}
  mkdir -p ${TARGET_DIR}

  rm -rf /tmp/Python-${PYTHON_VERSION}
  wget -SO- https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz | tar -xvzC /tmp
  cd /tmp/Python-${PYTHON_VERSION}
  # GitHub limits file sizes to 100MB. If the tarball ends up being bigger that that,
  # try removing "--enable-optimizations" below.
  ./configure --prefix=${TARGET_DIR} --with-ensurepip=install --enable-optimizations
  make
  rm -rf ${TARGET_DIR}
  export PATH=${TARGET_DIR}/bin:$PATH
  make install

  cd $TARGET_DIR/bin
  ln -s $(ls python* | egrep '^.*[0-9\.]{3}$') python || true
  ln -s $(ls pip* | egrep '^.*[0-9\.]{3}$') pip || true

  mkdir -p ${BASE_DIR}/repository
  cd ${TARGET_DIR}/..
  tar -vcjf ${BASE_DIR}/repository/${DISTRO}-${DISTRO_VERSION}-${PYTHON_VERSION}.tbz ${TARGET_DIR}
fi
