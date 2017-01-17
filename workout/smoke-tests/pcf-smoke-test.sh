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
git clone https://github.com/cloudfoundry-samples/spring-music.git
cd spring-music
# printf "\ncompiling app spring-music\n"
./gradlew build
cd ..
git clone https://github.com/vponnam/traveler.git
cd traveler
# printf "\ncompiling spring cloud services sample apps\n"
./gradlew build
cd ..
https://github.com/spring-cloud-services-samples/cook.git
cd cook
git checkout 1.2
./gradlew build
cd ..
dir=`pwd`
printf "\nPresent working directory is $dir\n"
#environment specs
sys1=""
rmq1="https://pivotal-rabbitmq.$sys1"
#on=("stest-org")
on=("test")
#sn=("stest-space")
sn=("con-test")
p1=$dir/spring-music/build/libs/spring-music.jar
p2=$dir/traveler/agency/
p3=$dir/traveler/company/
p4=$dir/cook/
# push count for load testing
push=1
if [ $push -ge 1 ]
then

# create org & space
#for i in "${on[@]}"; do printf "Creating org $i" cf create-org $i echo "Created org" $i cf t -o $i
#done
#create space
#for j in "${sn[@]}"; do printf "Creating space $j" cf create-space $j echo "created space $j" cf t -s $j
#done

# target org & space
cf login -a 	https://api.$sys1 -u $on -p $on -o $on -s $sn

#app push
for (( p=1; p<=$push; p++ ))
do
  echo "Push" $p cf t -o $on -s $sn
  echo "Pushing app spring-music from $p1"
#  cf push spring-music -p $p1 --random-route
  sleep 2
  cd $p2
#  cf push
  sleep 2
  cd $p3
#  cf push
done
fi

#mysql service tests
echo "Started testing MySQL Service"
i3=msql
cf cs p-mysql 100mb-dev $i3
until [ `cf service $i3 | grep -c "progress"` -eq 0 ]; do echo -n "*"
done
if [[ `cf service $i3 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating mysql service instance\n"; exit 1;
fi
if [[ `cf service $i3 | grep -c "succeeded"` -eq 1 ]]; then printf "\nsuccessfully created mysql service instance\n"
cf bs spring-music $i3
#cf restage spring-music
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
cf bs spring-music $i4
#cf restage spring-music
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
  cf bs company $i1
#  cf restage agency
#  cf restage company
fi
i5=config-server
cd $p4
./scripts/deploy.sh build/libs/cook-0.0.1-SNAPSHOT.jar
if [[ `cf service $i5 | grep -c "failed"` -eq 1 ]]; then printf "\noops..! failed creating config-server service instance\n"; exit 1;
fi
if [[ `cf service $i5 | grep -c "succeeded"` -eq 1 ]]; then printf "\nSuccessfully created config-server service instance\n"
  cf set-env cook TRUST_CERTS api.wise.com
  cf restage cook
fi

#Redis tests
echo "Started testing Redis Service"

#Single_Sign_on tests
echo "Started testing Single_Sign_on Service"

