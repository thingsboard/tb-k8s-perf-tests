#!/bin/bash
#
# ThingsBoard, Inc. ("COMPANY") CONFIDENTIAL
#
# Copyright © 2016-2019 ThingsBoard, Inc. All Rights Reserved.
#
# NOTICE: All information contained herein is, and remains
# the property of ThingsBoard, Inc. and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to ThingsBoard, Inc.
# and its suppliers and may be covered by U.S. and Foreign Patents,
# patents in process, and are protected by trade secret or copyright law.
#
# Dissemination of this information or reproduction of this material is strictly forbidden
# unless prior written permission is obtained from COMPANY.
#
# Access to the source code contained herein is hereby forbidden to anyone except current COMPANY employees,
# managers or contractors who have executed Confidentiality and Non-disclosure agreements
# explicitly covering such access.
#
# The copyright notice above does not evidence any actual or intended publication
# or disclosure  of  this source code, which includes
# information that is confidential and/or proprietary, and is a trade secret, of  COMPANY.
# ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
# OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT
# THE EXPRESS WRITTEN CONSENT OF COMPANY IS STRICTLY PROHIBITED,
# AND IN VIOLATION OF APPLICABLE LAWS AND INTERNATIONAL TREATIES.
# THE RECEIPT OR POSSESSION OF THIS SOURCE CODE AND/OR RELATED INFORMATION
# DOES NOT CONVEY OR IMPLY ANY RIGHTS TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS,
# OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
#

function installPerformance() {

    deviceStartIdx=$1
    deviceEndIdx=$2
    gatewayStartIdx=$3
    gatewayEndIdx=$4
    testApi=$5

    kubectl apply -f tb-performance-configmap.yml
    kubectl apply -f performance-setup.yml &&
    kubectl wait --for=condition=Ready pod/tb-performance-setup --timeout=600s &&
    kubectl exec tb-performance-setup -- sh -c 'export TEST_ENABLED=false; \
export DEVICE_CREATE_ON_START=true; \
export DEVICE_DELETE_ON_COMPLETE=false; \
export GATEWAY_CREATE_ON_START=true; \
export GATEWAY_DELETE_ON_COMPLETE=false; \
export UPDATE_ROOT_RULE_CHAIN=true; \
export REVERT_ROOT_RULE_CHAIN=false; \
export CUSTOMER_END_IDX=0; \
export TEST_API='$testApi'; \
export DEVICE_START_IDX='$deviceStartIdx'; \
export DEVICE_END_IDX='$deviceEndIdx'; \
export GATEWAY_START_IDX='$gatewayStartIdx'; \
export GATEWAY_END_IDX='$gatewayEndIdx'; \
export RULE_CHAIN_NAME=root_rule_chain_ce_random.json; \
start-tests.sh; touch /install-finished;'

    kubectl delete pod tb-performance-setup

}

deviceStartIdx=${1:-0}
deviceEndIdx=${2:-1000000}
gatewayStartIdx=${3:-0}
gatewayEndIdx=${4:-0}
testApi=${5:-device}

source .env

kubectl apply -f tb-namespace.yml
kubectl config set-context $(kubectl config current-context) --namespace=thingsboard

installPerformance ${deviceStartIdx} ${deviceEndIdx} ${gatewayStartIdx} ${gatewayEndIdx} ${testApi}
