#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=pkg-config
pkg_version=0.29.1

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#
function clean {
	rm -rf pkg-config-0.29.1
	rm -rf fakeroot
}

function extract {
	tar xvf pkg-config-0.29.1.tar.gz
	test_rc $?
}

function compile {
	cd pkg-config-0.29.1
	test_rc $?

	./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-compile-warnings \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.1
	test_rc $?

	make
	test_rc $?
}

function testpackage {
	make check
	test_rc $?
}

function installpackage {
	make DESTDIR=$curdir/fakeroot install
	test_rc $?
}

function package {
	cd $curdir/fakeroot
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
