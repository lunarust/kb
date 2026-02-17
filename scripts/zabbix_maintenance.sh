#!/bin/bash

#GET token
# curl -s -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc":"2.0","method":"user.login","params": {"user":"zabbix_maintenance","password":"MAInT!ZAbbI@21"}, "id":1,"auth":null}' https://zabbix-mgmt.mifinity.com/api_jsonrpc.php
echo "########## $1 ##########"
MAINTID=8
case "$1" in
'TEST1')
  MAINTID=5
;;
'DEMO1')
  MAINTID=6
;;
'STAGING1')
  MAINTID=9
;;
esac

AUTH=xzxzxzxzxzxzxzxzxz
NW=`date +%s`
URL=https://zabbix-mgmt.plop.com/api_jsonrpc.php

curl -X POST -H 'Content-Type: application/json-rpc' -d '{
    "jsonrpc": "2.0",
    "method": "maintenance.update",
    "params": {
        "maintenanceid": "'${MAINTID}'",
        "timeperiods":[{"timeperiodid":"'$((MAINTID+1))'",
        "timeperiod_type":"0",
        "every":"1",
        "month":"0",
        "dayofweek":"0",
        "day":"1",
        "start_time":"0",
        "period":"1200",
        "start_date":"'$NW'"}]
    },
    "auth": "'${AUTH}'",
    "id": '${MAINTID}'
}' ${URL}
