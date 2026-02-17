#!/bin/bash

HEALTHNODE=`/usr/local/bin/aws elbv2 describe-target-health --target-group-arn {{ salt['pillar.get']('lbtargetgroup') }} | \
jq '.TargetHealthDescriptions[] | "\(.TargetHealth.State)|\(.Target.Id)"'`

echo "============= check env health
$HEALTHNODE
=============
"
