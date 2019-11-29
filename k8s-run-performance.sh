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

function runPerformance() {

    messagesPerSecond=$1
    durationInSeconds=$2
    deviceStartIdx=$3
    deviceEndIdx=$4
    gatewayStartIdx=$5
    gatewayEndIdx=$6
    alarmStormStartSecond=$7
    alarmStormEndSecond=$8
    alarmsPerSecond=$9

    kubectl apply -f tb-performance-configmap.yml
    kubectl apply -f performance-run.yml &&
    kubectl wait --for=condition=Ready pod/tb-performance-run --timeout=600s &&
    kubectl exec tb-performance-run -- sh -c 'export DEVICE_START_IDX='$deviceStartIdx'; \
export DEVICE_END_IDX='$deviceEndIdx'; \
export GATEWAY_START_IDX='$gatewayStartIdx'; \
export GATEWAY_END_IDX='$gatewayEndIdx'; \
export MESSAGES_PER_SECOND='$messagesPerSecond'; \
export DURATION_IN_SECONDS='$durationInSeconds'; \
export ALARM_STORM_START_SECOND='$alarmStormStartSecond'; \
export ALARM_STORM_END_SECOND='$alarmStormEndSecond'; \
export ALARMS_PER_SECOND='$alarmsPerSecond'; \
export WARMUP_ENABLED='true'; \
start-tests.sh; touch /test-finished;'

#    kubectl delete pod tb-performance-run
}

messagesPerSecond=${1:-20000}
durationInSeconds=${2:-14400}
deviceStartIdx=${3:-0}
deviceEndIdx=${4:-1000000}
gatewayStartIdx=${5:-0}
gatewayEndIdx=${6:-1000}
alarmStormStartSecond=${7:-20}
alarmStormEndSecond=${8:-30}
alarmsPerSecond=${9:-200}

source .env

kubectl apply -f tb-namespace.yml
kubectl config set-context $(kubectl config current-context) --namespace=thingsboard

runPerformance ${messagesPerSecond} ${durationInSeconds} ${deviceStartIdx} ${deviceEndIdx} ${gatewayStartIdx} ${gatewayEndIdx} ${alarmStormStartSecond} ${alarmStormEndSecond} ${alarmsPerSecond}
