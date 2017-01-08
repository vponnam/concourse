#!/bin/sh

mkdir task1dir

ker=`uname -a` > task1dir/some-task1-files
echo "$ker"

ls
ls task1dir/*