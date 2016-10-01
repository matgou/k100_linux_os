#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=mpfr
pkg_version=3.1.4

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf mpfr-3.1.4.tar.xz
test_rc $?

cd mpfr-3.1.4
test_rc $?

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-3.1.4
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

