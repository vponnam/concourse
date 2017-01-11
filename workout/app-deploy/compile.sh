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

# publishing to git
apt-get update && apt-get install git -y
git clone https://github.com/vponnam/repo.git

cp -a resource-web-app/. repo/
ls repo/* |wc -l

cd repo

git config --global user.email "me@concourse.ci"
git config --global user.name "concourse"

git add .
git commit -m "Publishing outputs"

git remote add origin https://github.com/vponnam/repo.git
git push -u origin master

