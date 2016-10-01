#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=binutils
pkg_version=2.27

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf binutils-2.27.tar.bz2
test_rc $?

cd binutils-2.27
test_rc $?

mkdir $curdir/build
cd $curdir/build

../binutils-2.27/configure 	--prefix=/usr 	\
				--enable-shared \
				--disable-werror
test_rc $?

make tooldir=/usr
test_rc $?

make -k check
test_rc $?

make tooldir=/usr DESTDIR=$curdir/fakeroot install
test_rc $?

cd $curdir/fakeroot
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?

