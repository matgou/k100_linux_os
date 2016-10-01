#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=ncurses
pkg_version=6.0

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
tar xvf ncurses-6.0.tar.gz
test_rc $?

cd ncurses-6.0
test_rc $?

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
test_rc $?

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
test_rc $?

make
test_rc $?

make DESTDIR=$curdir/fakeroot install
test_rc $?

cd $curdir/fakeroot
test_rc $?

mv -v usr/lib/libncursesw.so.6* /lib
test_rc $?

ln -sfv ../../lib/$(readlink usr/lib/libncursesw.so) usr/lib/libncursesw.so
test_rc $?

mkdir -p usr/lib/pkgconfig
test_rc $?

for lib in ncurses form panel menu ; do
    rm -vf                    usr/lib/lib${lib}.so
    test_rc $?
    echo "INPUT(-l${lib}w)" > usr/lib/lib${lib}.so
    test_rc $?
    ln -sfv ${lib}w.pc        usr/lib/pkgconfig/${lib}.pc
    test_rc $?
done

rm -vf                     usr/lib/libcursesw.so
test_rc $?
echo "INPUT(-lncursesw)" > usr/lib/libcursesw.so
test_rc $?
ln -sfv libncurses.so      usr/lib/libcurses.so
test_rc $?

mkdir -pv       usr/share/doc/ncurses-6.0
test_rc $?
cp -v -R $curdir/ncurses-6.0/doc/* usr/share/doc/ncurses-6.0
test_rc $?

tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
test_rc $?
