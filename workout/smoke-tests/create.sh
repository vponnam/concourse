#!/bin/bash
set -e
export TERM=xterm

#sample apps
mkdir onetime-directory
cd onetime-directory
pwd
git clone https://github.com/vponnam/traveler.git
cd traveler
./gradlew build
cd ..
dir=`pwd`

#environment specs
p2=$dir/traveler/agency/
p3=$dir/traveler/company/

cf login -a https://api.$sys -u $user -p $pwd -o $org -s $sn --skip-ssl-validation
  cd $p2
  cf push
  sleep 3
  cd $p3
  cf push

# Get all existing circuit-breaker instances, if any!
cf s | grep p-circuit-breaker-dashboard | awk '{print $1}' > instances

# echo any existing create-failed instaces just for tracking
for i in $(cat instances)
do
  if [[ `cf service $i | grep -c "succeeded"` -eq 0 ]];
  then
  printf "\nFound instance $i in create-failed state.\n"
  fi
done

# Create a new instance with a random id
printf "\n******Attempting to create a new instance******\n"
id=$(( RANDOM % (9999 - 37 + 1 ) + 54 ))
cf cs p-circuit-breaker-dashboard standard circuit-breaker-$id
until [ `cf service circuit-breaker-$id | grep -c "progress"` -eq 0 ];
do
  echo -n "*"
done

# Check if create succeeded, and then delete any existing failed instances - create is an indication of any scs issue getting resolved by now!
if [[ `cf service circuit-breaker-$id | grep -c "succeeded"` -eq 1 ]];
then
  printf "\ncircuit-breaker-$id Successfully created!!, ***So deleted any failed instances from previous failed builds now***\n"
    for i in $(cat instances)
    do
      cf ds $i -f
    done
fi
