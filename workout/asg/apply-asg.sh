#!/bin/bash
set -e
export TERM=xterm

#merge individual json files
jq 'reduce inputs as $i (.; .resources += $i.resources)' src/workout/asg/asg-files/org-*.json > src/workout/asg/mergedasg.json

#execute the go-binary
if [[ $? = 0 ]]
then
  ./src/workout/asg/asg
else
  echo "Merging all the individual json files in asg-files folder failed\nExiting now..\n"
  exit 1
fi
