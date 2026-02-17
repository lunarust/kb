#!/bin/bash
#===============================================================================
#         FILE: backup_nginx_log.sh
#       AUTHOR: Celine H.
# ORGANIZATION: ---
#      VERSION: 0.0.1
#         TODO:
#===============================================================================
cd /var/log/nginx-ui/
DATE=`date '+%Y%m%d-%H%M%S'`
echo "$DATE"
tar cfz tc.access-SSL_${DATE}.tar.gz tc.access-SSL.log
rm -f tc.access-SSL.log
tar cfz web-access_${DATE}.tar.gz web-access.log
rm -f web-access.log
