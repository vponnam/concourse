*Pre-requisites*


##### Pipeline uses an org named *test* space *con-test* to push test apps bind them to platform services
###### Make sure either those are created or replace the script with proper details

Reference create syntax
	cf co test
	cf t -o test
	cf create-space con-test

##### Replace the user in the smoke-test.sh script who's assigned atleast a *space-developer* role and change the system domain name

##### This pipeline tests *Mysql, Rabbitmq, Spring-cloud-services (circuit-breaker and service-registry) and Redis* services. Please comment the sections those are not applicable to your environment.