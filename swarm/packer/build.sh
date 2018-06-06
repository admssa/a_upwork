#!/usr/bin/env bash

packer validate ./docker_foxpass.json


#export BUILD_VPC_ID=vpc-733a9815
#export BUILD_SUBNET_ID=subnet-9f2e2ac4
#export AWS_REGION=eu-west-1
export BUILD_VPC_ID=vpc-58926630
export BUILD_SUBNET_ID=subnet-72b09d3f
export AWS_REGION=eu-west-2

export foxpass_base_dn=test
export foxpass_pw=test
export foxpass_api_key=test

packer build ./docker_foxpass.json