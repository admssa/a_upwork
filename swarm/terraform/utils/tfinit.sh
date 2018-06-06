#!/bin/bash

export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY

terraform init -backend-config="./backends/backend-$1.json"