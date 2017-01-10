#!/bin/sh
pwd
ls
mkdir compiled-src
cd resource-web-app
ls
pwd
./gradlew assemble
ls build/libs/*
cd ..
cp resource-web-app/* /compiled-src/
