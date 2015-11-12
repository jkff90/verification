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
