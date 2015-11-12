#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#  This file <gen_list.pl> is a part of <verification> project
#  Copyright (C) 2015  An Pham (anphambk@gmail.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#!/bin/sh

#===============================================================================
# FILE: gen_list.sh
#
# Generate list files
#===============================================================================

#===============================================================================
# Cookie: Generate RTL list file
#===============================================================================
echo Creating RTL source files ...
rm -rf rtl.lst
#rtl
DIR=$PRJ_DIR/rtl
for FILE in `find $DIR -name '*.v'`
do
  echo $FILE | sed 's/^.\///'
done >> rtl.lst

#===============================================================================
# Cookie: Generate BEN list file
#===============================================================================
echo Creating BEN source files ...
rm -rf ben.lst
#tb
DIR=$PRJ_DIR/tb
for FILE in `find $DIR -name '*.v' -o -name '*.sv'`
do
  echo $FILE | sed 's/^.\///'
done >> ben.lst
#test
DIR=$PRJ_DIR/test
for FILE in `find $DIR -name '*.v' -o -name '*.sv'`
do
  echo $FILE | sed 's/^.\///'
done >> ben.lst
