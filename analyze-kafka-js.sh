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

#2019-11-29 15:42:05,436 [TB-Scheduling-2] INFO  o.t.s.s.script.RemoteJsInvokeService - Kafka JS Invoke Stats: pushed [0] received [0] invoke [0] eval [0] failed [0]

set -e

function printKafkaJsInvokeStats() {

    echo '                                                                    PUSHED,RECEIVED,DIFF,TIMEDOUT'
    grep 'Kafka JS Invoke Stats' tb-node-logs/* | awk '{gsub ( /[\[\]]/, "" ); print $1 "," $12 "," $14 "," $22}' | awk -F ',' '{pushed[$1] += $2; received[$1] += $3; timedOut[$1] += $4;} END{for (i in pushed) {print i,","pushed[i]","received[i]","pushed[i]-received[i]","timedOut[i]}}' | sort -t, -k4 -r -n

}


echo '**** Kafka JS Invoke Stats ****'
printKafkaJsInvokeStats

