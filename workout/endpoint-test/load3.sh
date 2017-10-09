#!/bin/bash

while true
do
        curl $r3 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        sleep 2
done
