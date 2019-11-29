#!/bin/bash

source .env

aws s3api create-bucket --bucket tb-performance --region $REGION
aws s3api put-bucket-versioning --bucket tb-performance --versioning-configuration Status=Enabled
