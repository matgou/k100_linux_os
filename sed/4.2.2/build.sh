#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=sed
pkg_version=4.2.2

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf sed-4.2.2.tar.bz2
test_rc $?

cd sed-4.2.2
test_rc $?

./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2
test_rc $?

make
test_rc $?

make html
test_rc $?

make check
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

make DESTDIR=$curdir/fakeroot -C doc install-html
test_rc $? 

cd $curdir/fakeroot
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
