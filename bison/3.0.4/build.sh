#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=bison
pkg_version=3.0.4

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
	log "Extract package bison-3.0.4.tar.xz"
	tar xf bison-3.0.4.tar.xz
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
	./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4 >> $curdir/make.log
	test_rc $?

	make >> $curdir/make.log
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
	make DESTDIR=$curdir/fakeroot install >> $curdir/make.log
	test_rc $?

	cd $curdir/fakeroot
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
