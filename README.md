# pageview counter

## run on local machine

set version of app in file named 'version', and then run script:
```sh
./run_local.sh
```



## run in AWS

Deploy app's infrastructure in AWS ECS

### Push docker image to a registry

You can use Docker Hub public repo for it:

```sh
docker tag node_app:<version> <user-name>/pageview_counter:<version>
docker push <user-name>/pageview_counter:<version>
```
And change image name in terraform, in file ./tf/modules/ecs/variables.tf, variable "image".

Also you can tag and push image when staring app local using scrip /run_local.sh. You'll need to uncomment this part.


### Set AWS credentials on your local machine
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html


### Create SSH keyapir in AWS.
This step can't be automated, so create or upload ssh keypair named 'admin':
  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html



### Auto-deploy to dev environment after commit in master brach
There is a post-commit hook triggers re-deployment in dev environment
To setup it: run command:
```sh
cp ./deploy_dev.sh .git/hooks/post-commit
```


### Deploy infrastructure and app in AWS

There are two terraform configurations in 'tf' dir: dev and prod. Please, set app version and number of desired containers and then run terraform.

For example if you want to deploy in prod environment run following commands:

```sh
cd ./tf/prod
terraform init
terraform plan
terraform apply
```

It will deploy 4 containers with version 1.0 (these values are set in terraform's config for dev envioronment).

Deployment script for dev environment: ./deploy_dev.sh

After this hook's execution you will see similar message:

```sh
Apply complete! Resources: 26 added, 0 changed, 0 destroyed.
sleeping 30 seconds and trying to connect to endpoint: tf-example-alb-ecs-1371947750.eu-central-1.elb.amazonaws.com
pageview counter: 1[master 2e99426] commit to test post-commit hook
```


