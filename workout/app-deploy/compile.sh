#!/bin/sh

ls compile-scripts/*
ls compiled-src/*

cd resource-web-app/spring-music
pwd
./gradlew assemble