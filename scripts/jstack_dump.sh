#!/bin/bash
#===============================================================================
#         FILE: jstack_dump.sh
#         FILE: clear_redis_cache.sh
#       AUTHOR: Celine
# ORGANIZATION: ---
#      VERSION: 0.0.1
#      CREATED:
#===============================================================================
i="0"

while [ $i -lt 8 ]
do
        dt=$(date '+%d-%m-%Y_%H_%M_%S');
        fname=jstack_${HOSTNAME}_${1}_${dt}
        cd /tmp/
        docker exec -t -i $1 jstack -l 1 > "/tmp/${fname}"
        #sleep 2
        tar -cvzf ${fname}.tar.gz "${fname}"
        echo "${HOSTNAME}:/tmp/$fname.tar.gz"


        i=$[$i+1]
done
