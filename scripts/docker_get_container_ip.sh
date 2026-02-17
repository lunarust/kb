#!/bin/bash
#===============================================================================
#         FILE: docker_get_container_ip.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#         TODO:
#===============================================================================

exec docker inspect --format='{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' "$@"
