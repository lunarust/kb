#!/bin/bash
#===============================================================================
#         FILE: docker_check_return_code.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#      UPDATED: Wed 01 Jul 2020 08:52:21 UTC
#===============================================================================
while ! docker logs check_container | grep -q "All systems reporting they are in WORKING"
do
        echo "checking..." #>> /tmp/checking
        sleep 4
done
sleep 10
EXITCODE=$(docker inspect -f {{.State.ExitCode}} check_container)
echo "Checkboot Status: $EXITCODE"

echo `date` "Operation completed check_container $EXITCODE"  >> /var/log/runstacklog/maintenance.html
