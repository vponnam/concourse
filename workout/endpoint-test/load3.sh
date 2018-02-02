#!/bin/bash

while true
do
        curl $r3 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        echo "app route is $r3"
        sleep 2
done
