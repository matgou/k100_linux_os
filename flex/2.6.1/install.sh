#!/bin/bash

echo "Post-Install Hook"
echo " - libtool"
/tmp/libtool-flex --finish /usr/lib
RC=$?
if [ "x$RC" != "x0" ]; then
	exit $RC
fi

rm /tmp/libtool-flex
exit $?
