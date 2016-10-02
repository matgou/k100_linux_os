#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

pkg_name=psmisc
pkg_version=22.21

#
# Load generic functions script
#
. $curdir/../../functions.sh
cd $curdir

#
# Extract source inside directory
#

function clean {
	rm -rf ${pkg_name}-${pkg_version}
	rm -rf fakeroot
	rm -rf make.log
}

function extract {
	tar xvf psmisc-22.21.tar.gz
	test_rc $?

	cd ${pkg_name}-${pkg_version}
	test_rc $?

	### Add extract commands here ###

	### End extract commands ###
}

function compile {
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###
	./configure --prefix=/usr >> $curdir/make.log
	test_rc $?

	make >> $curdir/make.log
	test_rc $?
	### End compile commands ###
}

function testpackage {
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###

	### End compile commands ###
}

function installpackage {
        cd $curdir/${pkg_name}-${pkg_version}

	### Add compile commands here ###
	make DESTDIR=$curdir/fakeroot install >> $curdir/make.log
	test_rc $?

	cd $curdir/fakeroot
	test_rc $?

	mkdir bin

	mv -v usr/bin/fuser   bin
	test_rc $?

	mv -v usr/bin/killall bin
	test_rc $?
	### End compile commands ###

	mkdir -p tmp/postinstall
	test_rc $?

	cp $curdir/install.sh tmp/postinstall/${pkg_name}-${pkg_version}.sh
}

function package {
        cd $curdir/fakeroot
	tar -czvf /packages/${pkg_name}-${pkg_version}.tgz * >> $curdir/make.log
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
