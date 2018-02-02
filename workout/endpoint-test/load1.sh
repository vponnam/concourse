#!/bin/bash

while true
do
        curl  $r1 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        echo "app route is $r1"
        sleep 2
done
