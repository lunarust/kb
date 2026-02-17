#!/bin/bash
#===============================================================================
#         FILE: clear_redis_cache.sh
#       AUTHOR: Celine
# ORGANIZATION: ---
#      VERSION: 0.0.1
#      CREATED:
#===============================================================================

FLUSHALL=$1
{% if salt['pillar.get']('cache_password') == "empty" %}
REDISCON="redis-cli -h {{ salt['pillar.get']('distributed_cache_address') }} -p {{ salt['pillar.get']('distributed_cache_port') }}"
{% else %}
REDISCON="redis-cli -a {{ salt['pillar.get']('cache_password') }} -h {{ salt['pillar.get']('distributed_cache_address') }} -p {{ salt['pillar.get']('distributed_cache_port') }}"
{% endif %}

if [[ "${FLUSHALL}" = "YES" ]]; then
  ${REDISCON} flushall
else
  while read -r line ; do
    if ! [[ $line =~ "Token" ]]; then
      echo "Clearing key: $line"
      ${REDISCON} --scan --pattern "${line}*" | xargs ${REDISCON} del
    fi
  done < <(${REDISCON} --scan --pattern '*'| cut -d ':' -f 1| sort | uniq)
fi
