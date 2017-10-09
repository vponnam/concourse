#!/bin/bash

while true
do
        curl -k $r2 | tr ',' '\n' | grep "404 Not Found" | head -2 | tail -1
        cf curl /v2/apps/$(cf app $(cf apps | grep $r2 |awk '{print $1}') --guid)/stats | grep -E "name|host"
        sleep 2
done
