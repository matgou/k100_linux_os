#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=shadow
pkg_version=4.2.1

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf shadow-4.2.1.tar.xz
test_rc $?

cd shadow-4.2.1
test_rc $?

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
test_rc $?
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
test_rc $?
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
test_rc $?
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
test_rc $?

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
test_rc $?

sed -i 's/1000/999/' etc/useradd
test_rc $?

./configure --sysconfdir=/etc --with-group-name-max-length=32
test_rc $?

make
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

cd $curdir/fakeroot
test_rc $?

mkdir bin
mv -v usr/bin/passwd bin
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
