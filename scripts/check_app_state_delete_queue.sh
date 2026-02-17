#!/bin/bash
echo " running.."
echo Checking queue before run loop
/opt/pegasus/scripts/rabbitmqadmin -u admin -p guest list queues|grep core.low.priority.queue
until ! docker ps |grep core ; do sleep 1 ; done
os=$(exec docker ps |grep core)
if [ "$os" = "" ]
then os="not running" ;
echo "Checking queue" ;
/opt/pegasus/scripts/rabbitmqadmin -u admin -p guest list queues|grep core.low.priority.queue ;
echo "deleting" ;
/opt/pegasus/scripts/rabbitmqadmin  -u admin -p guest delete queue name=core.low.priority.queue ;
echo "Checking if queue has been deleted" ;
/opt/pegasus/scripts/rabbitmqadmin -u admin -p guest list queues|grep core.low.priority.queue ;
else os="still running" ;
fi

exit 0
