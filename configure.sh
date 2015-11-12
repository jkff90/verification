#!/bin/bash

# Take a note that $0 does not mean "name of the program or script"
# It is actually "how I was called"
# So dir=`dirname $0` will return "/bin/bash" if calling by "source"
export VERLIB_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export UVM_HOME=$VERLIB_HOME/frameworks/uvm-1.1d
export UVC_HOME=$VERLIB_HOME/uvc
