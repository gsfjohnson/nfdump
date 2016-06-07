#!/bin/sh -xe

# This script starts docker

# Version of CentOS/RHEL
el_version=$1

 # Run tests in Container
if [ "$el_version" = "6" ]; then
  sudo docker run --rm=true -v `pwd`:/nfdump:rw centos:centos${OS_VERSION} /bin/bash -c "bash -xe /nfdump/build_inside_docker.sh ${OS_VERSION}"
  fi
