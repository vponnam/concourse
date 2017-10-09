#!/bin/bash

while true
do
        curl -k $r3 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        cf curl /v2/apps/$(cf app $(cf apps | grep $r3 |awk '{print $1}') --guid)/stats | grep -E "name|host"
        sleep 2
done
