#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=mpc
pkg_version=1.0.3

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf mpc-1.0.3.tar.gz
test_rc $?

cd mpc-1.0.3
test_rc $?

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.0.3
test_rc $?

make
test_rc $?

make html
test_rc $?

make check
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

make DESTDIR=$curdir/fakeroot install-html
test_rc $?

cd $curdir/fakeroot
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

