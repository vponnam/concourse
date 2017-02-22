#!/bin/bash
set -e

apt-get update
apt-get install wget git maven -y
mvn -v
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
mv cf /usr/local/bin
cf --version

#sample apps
mkdir onetime-directory
cd onetime-directory
pwd
git clone https://github.com/vponnam/spring-music.git
cd spring-music
./gradlew assemble
cd ..
git clone https://github.com/vponnam/rabbitmq-cloudfoundry-samples.git
cd rabbitmq-cloudfoundry-samples/spring/
mvn package
cd ../../
git clone https://github.com/vponnam/traveler.git
cd traveler
# printf "\ncompiling spring cloud services sample apps\n"
./gradlew build
cd ..
git clone https://github.com/spring-cloud-services-samples/cook.git
cd cook
git checkout 1.2
./gradlew build
cd ..
git clone https://github.com/vponnam/cf-redis-example-app.git
dir=`pwd`
printf "\nPresent working directory is $dir\n"
#environment specs
sys1="run-14.haas-59.pez.pivotal.io"
rmq1="https://pivotal-rabbitmq.$sys1"
#on=("stest-org")
on=("test")
#sn=("stest-space")
sn=("con-test")
p1=$dir/spring-music/
p2=$dir/traveler/agency/
p3=$dir/traveler/company/
p4=$dir/cook/
p5=$dir/cf-redis-example-app/
p6=$dir/rabbitmq-cloudfoundry-samples/spring/
# push count for load testing
push=1

if [ $push -ge 1 ]
then
cf login -a https://api.$sys1 -u $on -p $on -o $on -s $sn --skip-ssl-validation

#app push
for (( p=1; p<=$push; p++ ))
do
  echo "Push" $p cf t -o $on -s $sn
  cd $p1
  cf push
  sleep 2
  cd $p2
  cf push
  sleep 2
  cd $p3
  cf push
  sleep 2
  cd $p5
  cf p --no-start
done
fi

#mysql service tests
echo "Started testing MySQL Service"
i3=msql
cf cs p-mysql pre-existing-plan $i3
until [ `cf service $i3 | grep -c "progress"` -eq 0 ]; do echo -n "*"
done
if [[ `cf service $i3 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating mysql service instance\n"; exit 1;
fi
if [[ `cf service $i3 | grep -c "succeeded"` -eq 1 ]]; then printf "\nsuccessfully created mysql service instance\n"
cf bs spring-music $i3
cf restage spring-music
printf "\nSuccessfully tested mysql service"
fi

#Rabbitmq service tests
echo "Started testing Rabbitmq service"
if [[ `curl -v $rmq1` && $?=0 ]]; then printf "\nRabbitmq Management console returned response code 200 OK\n";
else printf "\nPlease check Rabbitmq Management console health status\n"
fi
i4=rmq
cf cs p-rabbitmq standard $i4
until [ `cf service $i4 | grep -c "progress"` -eq 0 ]; do echo -n "*"
done
if [[ `cf service $i4 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating Rabbitmq service instance\n"; exit 1;
fi
if [[ `cf service $i4 | grep -c "succeeded"` -eq 1 ]]; then printf "\nSuccessfully created Rabbitmq service instance\n"
cd $p6
cf p
cf restage rabbitmq-spring
printf "\nSuccessfully tested Rabbitmq service"
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
i5=config-server # work in progress

#Redis tests
printf "\nStarted testing Redis Service"
i6=redis
cf cs p-redis shared-vm $i6
cf bs redis-example-app $i6
cf start redis-example-app
route=`cf app redis-example-app |grep "urls"`
r1=`curl -X PUT $route/foo -d 'data=bar'`
printf "\nInserting data to Redis Cache"
r2=`curl -X GET r$route/foo`
printf "\nRetriving inserted value from Redis Cache"

#Clean-up task
printf "\nCleanup task"
cf us agency $i1
cf us agency $i2
cf us company $i2
cf us spring-music $i3
cf us rabbitmq-spring $i4
cf us redis-example-app $i6
cf ds $i1 -f
cf ds $i2 -f
cf ds $i3 -f
cf ds $i4 -f
cf ds $i6 -f

cf d spring-music -r -f
cf d rabbitmq-spring -r -f
cf d agency -r -f
cf d company -r -f
cf d redis-example-app -r -f
printf "\nSucessfully completed PCF smoke-test"
