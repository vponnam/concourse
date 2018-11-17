#!/bin/sh



# display OS kernal information
ker=`uname -a`
echo "$ker" > task1-output/some-task1-file

# Display content in output folder created above
ls task1-output/*
cat task1-output/some-task1-file

printf "\nUsername provided in task's params is: $user\n"
printf "Password provided in task1's params is: $passd\n"
