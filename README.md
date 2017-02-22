*Pre-requisites*


##### Pipeline uses an org named *test* space *con-test* to push test apps bind them to platform services
###### Make sure either those are created or replace the script with proper details, under the below path.

> path: concourse/workout/smoke-tests/pcf-smoke-test.sh

	sys1="sys-domain"	Replace with sys domain
	on=("test")			org-name
	sn=("con-test")		space-name

Reference create syntax
	
	cf co test
	cf t -o test
	cf create-space con-test

##### Replace the user in the smoke-test.sh script who's assigned atleast a *space-developer* role and change the system domain name

##### This pipeline tests *Mysql, Rabbitmq, Spring-cloud-services (circuit-breaker and service-registry) and Redis* services. Please comment the sections those are not applicable to your environment.

Set the pipeline as below reference
	
	fly sp -t <concourse-target> -c smokeTestv1.1-pipeline.yml -p <pipeline-name> -l creds.yml

craete a creds.yml with all the `{{}}` variables referred in smokeTestv1.1-pipeline.yml

> Note: some sections in workout folder are still work in progress.. (not fully baked) :)