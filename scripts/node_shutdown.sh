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

# stop app:
echo "==== Stopping Docker ===="

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

echo "==== shutdown ===="
echo "Time to STOP"
shutdown -h +5 "Server is going down. Please save your work."
