#!/bin/bash

export QUESTA_HOME="C:/modeltech64_10.5"
#export QUESTA_HOME="/cygdrive/c/modeltech64_10.5/include"

# Take a note that $0 does not mean "name of the program or script"
# It is actually "how I was called"
# So dir=`dirname $0` will return "/bin/bash" if calling by "source"
export VERILIB_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Fix Cygwin dirpath
if [[ "$(uname -s)" == "CYGWIN"* ]]; then
	export VERILIB_HOME=$(cygpath -d $VERILIB_HOME)
	export PLATFORM="cygwin"
else
	export PLATFORM="linux"
fi

## Add ARCH
export ARCH="$(uname -m)"

#export UVM_HOME=$VERILIB_HOME/frameworks/uvm-1.1d
export UVM_HOME=$VERILIB_HOME/frameworks/uvm-1.2
export UVC_HOME=$VERILIB_HOME/uvc

echo QUESTA_HOME=$QUESTA_HOME
echo VERILIB_HOME=$VERILIB_HOME
echo UVM_HOME=$UVM_HOME
echo UVC_HOME=$UVC_HOME
echo PLATFORM=$PLATFORM
echo ARCH=$ARCH
