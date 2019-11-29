#!/bin/bash

source .env

kops delete cluster --name $NAME --yes

