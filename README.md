*Instructions*

Referring to the sample-creds.yml file please input the necessary values and then rename it to creds.yml `mv sample-creds.yml creds.yml` *so that .gitignore will skip checking creds.yml to github*

This pipeline tests *Mysql, Rabbitmq, Spring-cloud-services (circuit-breaker and service-registry) and Redis* services. Please comment the sections in pcf-smoke-test.sh file those are not applicable to your environment.

##### Set the pipeline as below

`fly sp -t <concourse-target> -c pipeline.yml -p <pipeline-name> -l creds.yml`
