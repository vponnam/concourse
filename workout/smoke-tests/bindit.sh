#!/bin/bash
set -e
export TERM=xterm

cf login -a https://api.$sys -u $user -p $pwd -o $org -s $sn --skip-ssl-validation

# Checking if there is any healthy circuit-breaker instance
for instance in $(cf s | grep p-circuit-breaker-dashboard | awk '{print $1}')
do
  if [[ `cf service $instance | grep -c "succeeded"` -eq 1 ]];
  then
    circuitBreaker=$instance
  printf "\nFound this healthy instance: $instance.\n"
  fi
done

# Binding task: Using the healthy circuit-breaker instance for binding
cf bs agency $circuitBreaker
cf bs company $circuitBreaker

cf restage agency
cf restage company

# clean-up
cf us agency $circuitBreaker
cf us company $circuitBreaker
