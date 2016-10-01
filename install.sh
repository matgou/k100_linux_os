#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

#
# Load generic functions script
#
. $curdir/functions.sh

cd $curdir
test_rc $?

gunzip -c $1 | (cd / ; tar xvf - )
test_rc $?

ldconfig
test_rc $?
