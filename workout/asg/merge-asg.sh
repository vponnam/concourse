#!/bin/bash
set -e
export TERM=xterm

jq 'reduce inputs as $i (.; .resources += $i.resources)' src/workout/asg/asg-files/org-*.json > src/workout/asg/mergedasg.json
