#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=bzip2
pkg_version=1.0.6

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
function clean {
	rm -r bzip2-1.0.6
	rm -r fakeroot
}

function extract {
	cd $curdir

	tar xvf bzip2-1.0.6.tar.gz
	test_rc $?

	cd bzip2-1.0.6
	test_rc $?

	patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
	test_rc $?

	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
	test_rc $?

	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
	test_rc $?

}

function compile {
	make -f Makefile-libbz2_so
	test_rc $?

	make clean
	test_rc $?

	make
	test_rc $?
}
	
function testpackage {
	echo ""
}

function installpackage {
	make PREFIX=$curdir/fakeroot/usr install
	test_rc $?
}

function package {
	cd $curdir/fakeroot
	test_rc $?

	mkdir bin
	test_rc $?
	cp -v ../bzip2-1.0.6/bzip2-shared bin/bzip2
	test_rc $?

	mkdir lib
	test_rc $?
	cp -av ../bzip2-1.0.6/libbz2.so* lib
	test_rc $?

	ln -sv ../../lib/libbz2.so.1.0 usr/lib/libbz2.so
	test_rc $?
	rm -v usr/bin/{bunzip2,bzcat,bzip2}
	test_rc $?

	ln -sv bzip2 bin/bunzip2
	test_rc $?
	ln -sv bzip2 bin/bzcat
	test_rc $?

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
                installpackage
                package
                ;;
        "clean") clean ;;
        "extract") extract ;;
        "compile") compile ;;
        "testpackage") testpackage ;;
        "install") installpackage ;;
        "package") package ;;
        *) echo "usage: build.sh [all|clean|extract|compile|testpackage|install|package]"; exit 255 ;;
esac
