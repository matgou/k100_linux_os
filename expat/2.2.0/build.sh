#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=expat
pkg_version=2.2.0

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
	log "Extract package expat-2.2.0.tar.bz2"
	tar xf expat-2.2.0.tar.bz2
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
	./configure --prefix=/usr --disable-static >> $curdir/make.log
	test_rc $?

	make >> $curdir/make.log
	test_rc $?
	### End compile commands ###
}

function testpackage {
	log "Run tests"
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###
	make check >> $curdir/make.log

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

	mkdir -p usr/share/doc/

	install -v -dm755 usr/share/doc/expat-2.2.0
	test_rc $?

	install -v -m644 $curdir/${pkg_name}-${pkg_version}/doc/*.{html,png,css} usr/share/doc/expat-2.2.0
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
