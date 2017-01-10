#!/bin/sh
pwd
mkdir compiled-src
ls
cd resource-web-app
ls
pwd
./gradlew assemble
ls build/libs/*
cp ../compiled-src/
