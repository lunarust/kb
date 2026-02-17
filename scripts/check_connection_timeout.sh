#!/bin/bash
#===============================================================================
#         FILE: get_connection_time_out.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#      UPDATED: Wed 01 Jul 2020 08:52:21 UTC
#===============================================================================
LOGPATH=/var/log/app
WORKPATH=/opt/scripts
DEST="toto@plop.com"
YEST=`date -d '1 day ago' '+%Y-%m-%d'`
TODAY=$(date '+%Y-%m-%d')

grep -h "failed: Connection timed out" ${LOGPATH}/app-notifications_${YEST}.log*  | cut -d ' ' -f6| sort |  uniq -c > /tmp/timeout

sed -i  's/$/<br\/>/' /tmp/timeout
sed -i "/request/d" /tmp/timeout

BODY=`cat /tmp/timeout`
LINE=`cat /tmp/timeout | wc -l`
# create jira ticket and send email

if [[ $LINE -ne 0 ]]; then

echo "[${TODAY}] ###### ${HOSTNAME} TIMEOUT" > /var/log/app/notification_timeout.log
echo "${BODY} " >> /var/log/app/notification_timeout.log
echo "[${TODAY}] ######" >> /var/log/app/notification_timeout.log

fi
# clean up
#rm /tmp/timeout
