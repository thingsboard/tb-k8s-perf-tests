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

set -e

function printQueueInfo() {

    grepField=$1
    firstField=$2
    secondField=$3
    sortField=$4

    echo '                                                                    SUM,COUNT,AVG,MAX,CURRENT'
    grep "${grepField}" tb-node-logs/* | awk '{gsub ( /[\[\]]/, "" ); print $1 " " $'${firstField}' "," $'${secondField}'}' | awk -F ',' '{current[$1]=$2; a[$1] += $2; if(length(count[$1]) == 0) {count[$1]=0}; if($2>0) {count[$1]++}; if ($2>max[$1] || length(max[$1]) == 0) max[$1]=$2;} END{for (i in a) {avg[i]=0; if(count[i]>0) avg[i]=a[i]/count[i]; print i,","a[i]","count[i]","avg[i]","max[i]","current[i]}}' | sort -t, -k${sortField} -r -n

}



echo '**** ATTRIBUTES QUEUE SIZE ****'
printQueueInfo 'Attributes queueSize' 8 9 5

echo '**** ATTRIBUTES TOTAL ADDED ****'
printQueueInfo 'Attributes queueSize' 10 11 5

echo '**** TOTAL ADDED ****'
printQueueInfo 'Permits queueSize' 10 11 5

echo '**** QUEUE SIZE ****'
printQueueInfo 'Permits queueSize' 8 9 5

