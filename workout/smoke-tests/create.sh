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

# Get circuit-breaker instances
cf s | grep p-circuit-breaker-dashboard | awk '{print $1}' > instances
id=$(cat instances | wc -l)

# echo any failed instace names for tracking
for i in $(cat instances)
do
  if [[ `cf service $i | grep -c "succeeded"` -eq 0 ]];
  then
  printf "\nFound instance $i in create-failed state.\n"
  fi
done

# Create a new instance
printf "\n******Attempting to create a new instance******\n"
id=$(( RANDOM % (100 - 37 + 1 ) + 5 ))
cf cs p-circuit-breaker-dashboard standard circuit-breaker-$id
until [ `cf service circuit-breaker-$id | grep -c "progress"` -eq 0 ];
do
  echo -n "*"
done

# If create succedes, then delete any existing failed instances - because any scs broker issue should've got resolved by now
for j in $(cf s | grep p-circuit-breaker-dashboard | awk '{print $1}')
do
  if [[ `cf service circuit-breaker-$id | grep -c "succeeded"` -eq 1 ]];
  then
  printf "\ncircuit-breaker-$id Successfully created!!. So deleting any previously failed instances\n"
    for i in $(cat instances)
    do
      cf ds $i -f
    done
  fi
done
