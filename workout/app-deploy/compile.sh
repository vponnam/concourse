#!/bin/sh
set -e
set -x

pwd
ls
mkdir compiled-src
cd resource-web-app
ls
pwd
./gradlew assemble
ls build/libs/*
cd ..
cp -a resource-web-app/. compiled-src/
ls compiled-src/*

# publishing to git
apt-get update && apt-get install git -y
git clone https://github.com/vponnam/repo.git

cd repo

git config --global user.email "me@concourse.ci"
git config --global user.name "concourse"

git add ../resource-web-app/.
git commit -m "Publishing outputs"

git remote add origin https://github.com/vponnam/repo.git
git push -u origin master

