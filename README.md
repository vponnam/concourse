# Overview

Having hands on the keyboard/problem is the best way to learn things in real life, but how can we without having any idea of the problem would be the inevitable question? So, here is an initiative where we would like to help you getting started with just enough basics, and for now the topic is concourse(automation tool) and cloud foundry related area.  

```
If you can't explain it simply, you don't understand it well enough.

- Albert Einstein
```
So here is an attempt to make the things we discuss easy for now and forever.  

This repository consists of basic examples that will greatly help getting started with concourse pipelines and tasks at a super fast-paced manner. We do cover few genuine real time examples that will help achieve most of the operational day2 activities in cloud foundry towards the end.  

Plan of Action:
- [Why concourse](#why-concourse)
  - [Security](#security)
  - [Can I run parallel tasks at scale](#run-at-scale)
  - [Custom workloads depending on operating-system and runtime libraries](#custom-workloads)
- [Cloud foundry and concourse along the journey](#Cloudfoundry-And-Concourse)
   - [Basic pipeline](#basic-pipeline)
   - [A simple smoke-test that can scan the whole shop](#smoke-test)
   - [What else we can achieve and where do we go from here](#next-steps)

## Why Concourse
Concourse is a simple CI/CD tool, which will help automate almost any day to day system tasks that can run on linux based OS. The task execution can be based on webhook, time, invoking APIs or etc (Covered more in the official doc).  
Official doc reference: https://concourse-ci.org/
### Security
All tasks will be executed in a separate and isolated container, so a single worker node(VM) that's running multiple tasks in isolated containers prevents any unanticipated bad task cascading the problem to other tasks running across different containers. All containers are unprivileged by default and a task running inside a container cannot issue sudo commands against host OS.  
These container's lifetime is only valid until task execution time (which will typically last for few sec's to min's), hence leaving very limited scope for any unknown malicious process to reach other workloads.  
### Run At Scale  
On a single worker node, there can be as many containers that can be executed at scale until the VM resource limit has reached. This will enable the functionality of running multiple pipeline jobs at the same time for concurrent tasks.  
### Custom workloads
Any linux based docker image can be deployed for executing the task. The image can be from public or private docker registry. Good thing is that the image itself can be created with any runtime dependencies (Hopefully something that's trustable or our company approved) and this completely eliminates the legacy dependencies management for all workloads run on a common VM.  
[Here](workout/1job-2tasks/task1.yml) is a quick example to get an basic idea of image config in concourse.

# Cloudfoundry and Concourse
Automating cloud foundry deployments and/or day-to-day tasks using concourse is a deadly combination. The rich set of functionalities credential management greatly helps avoid passing plain text fields across tasks, jobs.  

## Basic pipeline  
Step 1: Look at the pipeline structure [here](workout/1job-2tasks/basic-pipeline.yml)  
We have resources and jobs section. Resources section points to the configurational related items and it tells concourse the type of resource, for example: github is a resource type which stores all the task configurational details (such as a bash script, some code.. etc). Jobs section defines the sequence of tasks that we intend to execute.  
Step 2: Job tasks  
- Task config  
Task config is the configuration that will define the type of docker image the task has to use and input files and output files. Input files are like github repo that has all the code that we intend to execute, Output files are for passing the output from previous task as a dependency for next task. [Here](workout/1job-2tasks/task1.yml) is a example task config yml file.  

- Task script
The actual script to be executed. [Here](workout/1job-2tasks/task1.sh) is a example task script.  

Executing the pipeline in a concourse environment:    
1. login and setup your fly target as mentioned [here](https://concourse-ci.org/fly.html#fly-login)
2. git clone git@github.com:vponnam/concourse.git && cd concourse
3. Make sure to add cf-user and cf-pwd values in `sample-creds.yml` file and just fly it `fly -t <your-target> sp -p basic-pieline -c workout/1job-2tasks/task1.ymlbasic-pipeline.yml -l sample-creds.yml`  

After successful execution you should see a pipeline names basic-pieline in your concourse webUI, you can unpase it and trigger it by clicking `+` symbol at the top right corner.  

## Smoke Test
*Instructions*  
Referring to the sample-creds.yml file please input the necessary values and then rename it to creds.yml `mv sample-creds.yml creds.yml` *so that .gitignore will skip checking creds.yml to github*

This pipeline tests *Mysql, Rabbitmq, Spring-cloud-services (circuit-breaker and service-registry) and Redis* services. Please comment the sections in pcf-smoke-test.sh file those are not applicable to your environment.

##### Set the pipeline as below

`fly sp -t <concourse-target> -c pipeline.yml -p <pipeline-name> -l creds.yml`

## Next Steps
Having this basic idea will greatly help understanding most of the complex jobs at an initial glance from other resources, also building complex pipelines will become very easy and good luck with your learning and implementation curve.  
The [official docs](https://concourse-ci.org/tutorials.html) cover good tutorials and decent explanations about specific details such as pipelines, resources, jobs, tasks and how they all tie together in a big picture.
