#!/bin/bash

source .env

kops validate cluster --name $NAME
