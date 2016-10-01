#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=gmp
pkg_version=6.1.1

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf gmp-6.1.1.tar.xz
test_rc $?

cd gmp-6.1.1
test_rc $?

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.1
test_rc $?

make
test_rc $?

make html
test_rc $?

make check 2>&1 | tee gmp-check-log
nb=`awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log`
if [ "x$nb" != "x190" ]
then
  exit 255
fi

make DESTDIR=$curdir/fakeroot install
test_rc $?

make DESTDIR=$curdir/fakeroot install-html
test_rc $?

cd $curdir/fakeroot
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

