#!/usr/bin/env sh

set -eux

for DISTRO in\
  alpine:latest\
  centos:latest\
  debian:latest\
  fedora:latest\
  ubuntu:18.04\
  ubuntu:20.04
do
  docker run --rm -itv $(pwd):/root -w /root ${DISTRO} ./build.sh
  sudo chown -R $(whoami) repository
done
