#!/bin/bash
set -x

git clone src 
echo "success" > src/workout/smoke-tests/state
git add .
git commit -m "Recoding success state"
