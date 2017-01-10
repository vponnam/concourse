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
cp -a resource-web-app/. compiled-src/
ls compiled-src/*

