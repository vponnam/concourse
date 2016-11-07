# concourse
# Below instructions are for installing concourse 3 node cluster with a bosh director

Step 1:
Bosh Cloud Config

Ref:
https://concourse.ci/installing.html
Cloud-Config
http://bosh.io/docs/openstack-cpi.html#cloud-config

Step 2:
Concourse Manifest Properties

Ref: https://concourse.ci/clusters-with-bosh.html#prepping-bosh

Notes: No tsl certs for web.
       Reserve IP's in cloud-config.

Step 3:
bosh deployment councourse.yml
bosh deploy

After successfully deploying 3 node (web/0, db/0, worker/0) concourse cluster, assign a floting IP to web/0 job and access concourse web ui using http://FloatingIP:8080 

fly binary:
download the latest fly binary from https://concourse.ci/downloads.html

chmod +x ~/fly_darwin_amd64
mv ~/fly_darwin_amd64 /usr/local/bin/fly
fly -v # should report current fly binary version 

Setting fly target

fly --target tutorial login  --concourse-url http://FIP:8080
fly -t tutorial sync

can verify the target api 'cat ~/.flyrc'

Tutorial:
https://github.com/starkandwayne/concourse-tutorial
