#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

export log=/tmp/install.log
export error_msg="\033[31mError see $log\033[0m" 

rm $log
#
# Load generic functions script
#
. $curdir/functions.sh

cd $curdir
test_rc $?

log "Extract ..."
gunzip -c $1 | (cd / ; tar xvf - ) >> $log
test_rc $? $error_msg

log "Run ldconfig ..."
ldconfig >> $log
test_rc $? $error_msg

log "Run Post-Install Hook ..."
/`tar tf $1 | grep "tmp/postinstall" | tail -1` >> $log
test_rc $? $error_msg
