#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=attr
pkg_version=2.4.47

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf attr-2.4.47.src.tar.gz
test_rc $?

cd attr-2.4.47
test_rc $?

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
test_rc $?

sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
test_rc $?

./configure --prefix=/usr 	\
            --bindir=/bin 	\
            --disable-static
test_rc $?

make
test_rc $?

make -j1 tests root-tests

make DESTDIR=$curdir/fakeroot install install-dev install-lib
test_rc $?

cd $curdir/fakeroot
test_rc $?

chmod -v 755 usr/lib/libattr.so
test_rc $?

mkdir lib
mv -v usr/lib/libattr.so.* lib/
ln -sfv ../../lib/$(readlink usr/lib/libattr.so) usr/lib/libattr.so

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
