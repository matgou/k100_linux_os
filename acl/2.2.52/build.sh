#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=acl
pkg_version=2.2.52

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf acl-2.2.52.src.tar.gz
test_rc $?

cd acl-2.2.52
test_rc $?

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
test_rc $?

sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
test_rc $?

sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c
test_rc $?

./configure --prefix=/usr    \
            --bindir=/bin    \
            --disable-static \
            --libexecdir=/usr/lib
test_rc $?

make
test_rc $?

make DESTDIR=$curdir/fakeroot install install-dev install-lib
test_rc $?

cd $curdir/fakeroot
test_rc $?

chmod -v 755 usr/lib/libacl.so
test_rc $?

mkdir lib
mv -v usr/lib/libacl.so.* /lib
test_rc $?

ln -sfv ../../lib/$(readlink usr/lib/libacl.so) usr/lib/libacl.so

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
