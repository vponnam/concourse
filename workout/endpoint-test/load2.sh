#!/bin/bash

while true
do
        curl  $r2 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        echo "app route is $r2"
        sleep 2
done
