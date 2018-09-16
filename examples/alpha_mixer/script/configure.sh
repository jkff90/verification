#!/bin/bash
source ../../../configure.sh
cd ..
export PRJ_DIR=`pwd`
cd -

## Fix Cygwin dirpath
unameOut="$(uname -s)"
if [[ "$(uname -s)" == "CYGWIN"* ]]; then
	export PRJ_DIR=$(cygpath -d $PRJ_DIR)
fi

echo PRJ_DIR=$PRJ_DIR