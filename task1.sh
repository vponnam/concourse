#!/bin/sh

# mkdir task1-output

ker=`uname -a` > task1-output/some-task1-files
echo "$ker"

ls
cat task1-output/some-task1-files