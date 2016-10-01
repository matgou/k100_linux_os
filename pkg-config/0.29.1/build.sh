#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=pkg-config
pkg_version=0.29.1

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf pkg-config-0.29.1.tar.gz
test_rc $?

cd pkg-config-0.29.1
test_rc $?

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-compile-warnings \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.1
test_rc $?

make
test_rc $?

make check
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

cd $curdir/fakeroot
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

