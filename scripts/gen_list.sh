#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#  This file <genlist.sh> is a part of <verification> project
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
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#!/bin/sh

#===============================================================================
# FILE: genlist.sh
#
# Generate list files
#===============================================================================

#===============================================================================
# Cookie: Generate RTL list file
#===============================================================================
echo Creating RTL source files ...
rm -rf rtl.f
DIR=$PRJ_DIR/rtl
for FILE in `find $DIR -name '*.v'`
do
  echo $FILE | sed 's/^.\///'
done >> rtl.f

#===============================================================================
# Cookie: Generate ENV list file
#===============================================================================
echo Creating ENV source files ...
rm -rf env.f
DIR=$PRJ_DIR/env
for FILE in `find $DIR -name '*.v' -o -name '*.sv'`
do
  echo $FILE | sed 's/^.\///'
done >> env.f

#===============================================================================
# Cookie: Generate TEST list file
#===============================================================================
echo Creating TEST source files ...
rm -rf test.f
DIR=$PRJ_DIR/test
for FILE in `find $DIR -name '*.v' -o -name '*.sv'`
do
  echo $FILE | sed 's/^.\///'
done >> test.f