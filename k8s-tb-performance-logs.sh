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

echo Starting tb-performance logs collection ...

mkdir -p tb-performance-logs

rm -rf tb-performance-logs/*

echo Waiting for tb-performance clients...

kubectl rollout status statefulset/tb-performance-run || { echo 'Failed to get tb-performance-run statefulset status. Exiting...' ; exit 1; }

nodes=($(kubectl get pods | grep 'tb-performance-run-' | awk '{print $1}'))

len=${#nodes[@]}

echo Found $len tb-performance clients...
if [ "$len" -eq "0" ]; then
   echo "No tb-performance-run pods found! Exiting...";
   exit 1;
fi

for (( i=0; i<$len; i++ ))
do
    node=${nodes[$i]}
    echo $i: $node
    kubectl logs -f $node &> tb-performance-logs/$node.log &
done

echo Collecting tb-performance logs...

wait

echo Finished tb-performance logs collection.

