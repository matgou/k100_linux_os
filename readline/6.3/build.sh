#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=readline
pkg_version=6.3

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#

function clean {
	log "Run clean"
	rm -rf ${pkg_name}-${pkg_version}
	rm -rf fakeroot
	rm -rf make.log
}

function extract {
	log "Extract package readline-6.3.tar.gz"
	tar xf readline-6.3.tar.gz
	test_rc $?

	cd ${pkg_name}-${pkg_version}
	test_rc $?

	### Add extract commands here ###

	### End extract commands ###
}

function compile {
	log "Run compilation "
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###
	patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch
	test_rc $?

	sed -i '/MV.*old/d' Makefile.in
	test_rc $?

	sed -i '/{OLDSUFF}/c:' support/shlib-install
	test_rc $?

	./configure --prefix=/usr    \
        	    --disable-static \
        	    --docdir=/usr/share/doc/readline-6.3 >> $curdir/make.log
	test_rc $?

	make SHLIB_LIBS=-lncurses >> $curdir/make.log
	test_rc $?
	### End compile commands ###
}

function testpackage {
	log "Run tests"
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###

	### End compile commands ###
}

function installpackage {
	log "Run installation"
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###
	make DESTDIR=$curdir/fakeroot SHLIB_LIBS=-lncurses install >> $curdir/make.log
	test_rc $?

	cd $curdir/fakeroot
	test_rc $?

	mkdir lib
	mv -v usr/lib/lib{readline,history}.so.* lib
	test_rc $?

	ln -sfv ../../lib/$(readlink usr/lib/libreadline.so) usr/lib/libreadline.so
	test_rc $?

	ln -sfv ../../lib/$(readlink usr/lib/libhistory.so ) usr/lib/libhistory.so
	test_rc $?

	mkdir -p usr/share/doc/readline-6.3
	install -v -m644 $curdir/${pkg_name}-${pkg_version}/doc/*.{ps,pdf,html,dvi} usr/share/doc/readline-6.3
	test_rc $?

	### End compile commands ###

	mkdir -p tmp/postinstall
	test_rc $?

	cp $curdir/install.sh tmp/postinstall/${pkg_name}-${pkg_version}.sh
}

function package {
	log "Create package"
        cd $curdir/fakeroot
	tar -czf /packages/${pkg_name}-${pkg_version}.tgz *
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
