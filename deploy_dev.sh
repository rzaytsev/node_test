#!/usr/bin/env bash

cd ./tf/dev || exit

version=$(cat ../../version)
echo "deploying version: $version"

terraform init
terraform plan -var "app_ver=$version"
terraform apply -auto-approve -var "app_ver=$version"

url=$(terraform output -module=ecs elb_hostname)

echo "sleeping 30 seconds and trying to connect to endpoint: $url"
sleep 30
curl "$url"

