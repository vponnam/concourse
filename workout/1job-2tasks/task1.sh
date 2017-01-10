#!/bin/sh

# mkdir task1-output

ker=`uname -a`
echo "$ker" > task1-output/some-task1-file

ls task1-output/*
cat task1-output/some-task1-file
