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
printf "\nPresent working directory is $dir\n"
#environment specs
p2=$dir/traveler/agency/
p3=$dir/traveler/company/
p4=$dir/cook/
# Increase push count for load testing
push=1
if [ $push -ge 1 ]
then
cf login -a https://api.$sys -u $user -p $pwd -o $org -s $sn --skip-ssl-validation
#app push
for (( p=1; p<=$push; p++ ))
do
  echo "Push" $p cf t -o $org -s $sn
  cd $p2
  cf push
  sleep 2
  cd $p3
  cf push
done
fi

#spring-cloud-service tests
echo "Started testing spring-cloud-service Service"
i1=smoke-test-cbd
cf cs p-circuit-breaker-dashboard standard $i1
until [ `cf service $i1 | grep -c "progress"` -eq 0 ]; do echo -n "*"
done
if [[ `cf service $i1 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating circuit-breaker-dashboard service instance\n"; exit 1;
fi
if [[ `cf service $i1 | grep -c "succeeded"` -eq 1 ]]; then printf "\nSuccessfully created circuit-breaker-dashboard service instance\n"

fi
i2=smoke-test-sr
cf cs p-service-registry standard $i2
until [ `cf service $i2 | grep -c "progress"` -eq 0 ]; do echo -n "*"
done
if [[ `cf service $i2 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating service-registry service instance\n"; exit 1;
fi
if [[ `cf service $i2 | grep -c "succeeded"` -eq 1 ]]; then printf "\nsuccessfully created service-registry service instance\n"
  cf bs agency $i1
  cf bs agency $i2
  cf bs company $i2
  cf restage agency
  cf restage company
fi

#Clean-up task
printf "\nCleanup task"
cf us agency $i1
cf us agency $i2
cf us company $i2
cf ds $i1 -f
cf ds $i2 -f

cf d agency -r -f
cf d company -r -f
cf delete-orphaned-routes -f
printf "\nSucessfully completed PCF smoke-test"
