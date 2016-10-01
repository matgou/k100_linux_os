#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=gcc
pkg_version=6.2.0

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#

function clean {
	rm -rf gcc-6.2.0
	rm -rf fakeroot
}

function extract {
	tar xvf gcc-6.2.0.tar.bz2
	test_rc $?

	cd gcc-6.2.0
	test_rc $?

	mkdir build
	test_rc $?

	cd build
	test_rc $?
}

function compile {
        cd $curdir/gcc-6.2.0/build
	SED=sed                               \
	../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib
	test_rc $?

	make
	test_rc $?

	ulimit -s 32768
	test_rc $?
}

function testpackage {
        cd $curdir/gcc-6.2.0/build
	make -k check

	../contrib/test_summary > DESTDIR=$curdir/test_summary.log
}

function install {
        cd $curdir/gcc-6.2.0/build
	make DESTDIR=$curdir/fakeroot install
	test_rc $?

	cd $curdir/fakeroot
	test_rc $?

        mkdir lib
	ln -sv ../usr/bin/cpp lib/cpp
	ln -sv gcc usr/bin/cc

	install -v -dm755 usr/lib/bfd-plugins
	test_rc $?

	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/6.2.0/liblto_plugin.so \
        	usr/lib/bfd-plugins/
	test_rc $?

	mkdir -pv usr/share/gdb/auto-load/usr/lib
	test_rc $?

	mv -v usr/lib/*gdb.py usr/share/gdb/auto-load/usr/lib
	test_rc $?
}

function package {
        cd $curdir/fakeroot
	tar -czvf /packages/${pkg_name}-${pkg_version}.tgz *
	test_rc $?
}

if [ $# -gt 0 ]; then
	ARG=$1
else
	ARG=all
fi

case "$ARG" in
	"all")
		clean
		extract
		compile
		testpackage
		install
		package
		;;
	"clean") clean ;;
	"extract") extract ;;
	"compile") compile ;;
	"testpackage") testpackage ;;
	"install") install ;;
	"package") package ;;
	*) echo "usage: build.sh [all|clean|extract|compile|testpackage|install|package]"; exit 255 ;;
esac
