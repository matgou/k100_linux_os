#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=libcap
pkg_version=2.25

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf libcap-2.25.tar.xz
test_rc $?

cd libcap-2.25
test_rc $?

sed -i '/install.*STALIBNAME/d' libcap/Makefile
test_rc $?

make
test_rc $?

make RAISE_SETFCAP=no prefix=$curdir/fakeroot/usr install
test_rc $?

cd $curdir/fakeroot
test_rc $?

chmod -v 755 usr/lib64/libcap.so
test_rc $?

mkdir lib
mv -v usr/lib64/libcap.so.* lib/
test_rc $?

ln -sfv ../../lib/$(readlink usr/lib64/libcap.so) usr/lib64/libcap.so
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
