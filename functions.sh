#!/bin/bash

function test_rc() {
	rc=$1

	if [ "x$rc" != "x0" ]
	then
		exit $rc
	fi
}
