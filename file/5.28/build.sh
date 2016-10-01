#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=file
pkg_version=5.28

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf file-5.28.tar.gz
test_rc $?

cd file-5.28
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

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

