#!/bin/bash
#===============================================================================
#         FILE: app_check_state_delete_queue.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#===============================================================================

echo " running.."
echo Checking queue before run loop
/opt/app/scripts/rabbitmqadmin -u admin -p guest list queues|grep low.priority.queue
until ! docker ps |grep core ; do sleep 1 ; done
os=$(exec docker ps |grep core)
if [ "$os" = "" ]
then os="not running" ;
echo "Checking queue" ;
/opt/app/scripts/rabbitmqadmin -u admin -p guest list queues|grep low.priority.queue ;
echo "deleting" ;
/opt/app/scripts/rabbitmqadmin  -u admin -p guest delete queue name=low.priority.queue ;
echo "Checking if queue has been deleted" ;
/opt/app/scripts/rabbitmqadmin -u admin -p guest list queues|grep low.priority.queue ;
else os="still running" ;
fi

exit 0
