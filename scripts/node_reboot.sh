#!/bin/bash
#===============================================================================
#         FILE: reboot_gracefully.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#         TODO:
#===============================================================================
if [ $EUID != 0 ]
  then echo -e "${RED}Please run as root!${nc}"
  exit
fi

echo "==== Clean imagines ===="
# replacing rmi with system prune - otherwise pegasus won't start on boo
docker rmi -f $(docker images -q)
# docker prune -a --force --filter "until=2190h"



# when we have a policy on rabbitmq for mirrored queues we can skip that stage
# rabbitmqctl set_policy ha-two "^[a-z]*(?:\-[a-z]+)*(?:\.[a-z]+)*(?:\_[a-z]+)*$" \
#	'{"ha-mode":"exactly","ha-params":2,"ha-promote-on-failure":"always","ha-promote-on-shutdown":"when-synced"}'
# I'd like to find a proper way to redisrtibute all queues belonging to the current node...
# stop pegasus:
echo "==== Stopping Docker app ===="

/opt/app/scripts/stop.sh
echo "==== Sleeping 5 ===="

sleep 5
echo "==== Shutdown Rabbitmq ===="

# Stop our temporary RabbitMQ node & clean all persistent files
#rabbitmqctl shutdown
systemctl stop rabbitmq-server
#rm -fr /tmp/{log,$RABBITMQ_NODENAME*}

echo "==== Shutdown Redis ===="
systemctl stop redis


echo "==== Sleeping 5 ===="
sleep 5

echo "==== Reboot ===="
echo "Time to reboot"
init 6
