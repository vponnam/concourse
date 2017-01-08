#!/bin/sh

# mkdir task1-output

ker=`uname -a` > task1-output/some-task1-files
echo "$ker"

ls task1-output/*
cat task1-output/some-task1-files