#!/bin/bash

function test_rc() {
	rc=$1

	if [ "x$rc" != "x0" ]
	then
		if [ $# -gt 1 ]; then
			shift
			log $*
		fi
		exit $rc
	fi
}

function log() {
	if [ "x$log" != "x" ]; then
		echo -e "[`date +'%Y/%m/%d %H:%M:%S'`] $*" | tee -a $log
	else
		echo -e "[`date +'%Y/%m/%d %H:%M:%S'`] $*"
	fi
}
