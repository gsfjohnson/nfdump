#!/bin/sh -xe

OS_VERSION=$1
PKG=nfdump

ls -l /home

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${OS_VERSION}.noarch.rpm

# Broken mirror?
echo "exclude=mirror.beyondhosting.net" >> /etc/yum/pluginconf.d/fastestmirror.conf

yum -y install yum-plugin-priorities
yum -y install rpm-build gcc gcc-c++ bzip2-devel cmake git tar gzip make autotools flex byacc

# Prepare the RPM environment
mkdir -p /tmp/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cat >> /etc/rpm/macros.dist << EOF
%dist .el${OS_VERSION}
EOF

cp ${PKG}/extra/${PKG}.spec /tmp/rpmbuild/SPECS
package_version=`grep Version ${PKG}/extra/${PKG}.spec | awk '{print $2}'`
pushd ${PKG}
git archive --format=tar --prefix=${PKG}-${package_version}/ HEAD  | gzip >/tmp/rpmbuild/SOURCES/${PKG}-${package_version}.tar.gz
popd

# Build the RPM
rpmbuild --define '_topdir /tmp/rpmbuild' -ba /tmp/rpmbuild/SPECS/${PKG}.spec

# After building the RPM, try to install it
# Fix the lock file error on EL7.  /var/lock is a symlink to /var/run/lock
mkdir -p /var/run/lock

yum localinstall -y /tmp/rpmbuild/RPMS/noarch/${PKG}-${package_version}*

# Run unit tests
#pushd htcondor-ce/tests/
#python run_tests.py
#popd
