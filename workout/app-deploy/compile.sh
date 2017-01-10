#!/bin/sh

ls compile-scripts/*

git clone https://github.com/cloudfoundry-samples/spring-music.git
cd spring-music
pwd
./gradlew assemble