#!/bin/bash

script_path=`realpath $0`
curdir=`dirname $script_path`

#
# Load generic functions script
#
. $curdir/functions.sh
cd $curdir

package=`basename $1 | sed "s/.tar.*//" | sed "s/.tgz//"`

pkg_name=`echo $package | sed "s/^\(.*\)-.*/\1/"`
pkg_version=`echo $package | sed "s/.*-\(.*\)$/\1/"`

echo $pkg_name
echo $pkg_version

mkdir -p $curdir/$pkg_name/$pkg_version
test_rc $?

sed "s/###PKG_NAME###/$pkg_name/g" 	build_example.sh | \
sed "s/###PKG_VERSION###/$pkg_version/g" 		 | \
sed "s/###PKG_ARCHIVE###/`basename $1`/g" > $curdir/$pkg_name/$pkg_version/build.sh
test_rc $?

cp $1 $curdir/$pkg_name/$pkg_version/
test_rc $?

cp install_example.sh $curdir/$pkg_name/$pkg_version/install.sh
test_rc $?
