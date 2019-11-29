#!/bin/bash

source .env

kops create -f ./cluster/tb-cluster.yaml

kops create -f ./cluster/tb-instancegroup.yaml

kops create secret --name tb-performance.k8s.local sshpublickey admin -i $SSH_PUBLIC_KEY

kops update cluster $NAME -y
