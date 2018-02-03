#!/bin/bash
set -x

git clone src task-status
echo "success" > task-status/workout/smoke-tests/state
git add .
git commit -m "Recoding success state"
