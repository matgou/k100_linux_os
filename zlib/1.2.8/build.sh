#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=zlib
pkg_version=1.2.8

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf zlib-1.2.8.tar.xz
test_rc $?

cd zlib-1.2.8
test_rc $?

./configure --prefix=/usr
test_rc $?

make
test_rc $?

make check
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

cd $curdir/fakeroot
test_rc $?

mv -v usr/lib/libz.so.* lib
test_rc $?

ln -sfv ../../lib/$(readlink /usr/lib/libz.so) usr/lib/libz.so
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

