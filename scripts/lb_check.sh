
echo "Getting number of host that aren't me and healthy on LB"
# Fetching local IP address
MYIP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
# Get the list of nodes from LB Target group filtering with: IP != [current Host] && status = Healthy
HEALTHNODE=`/usr/local/bin/aws elbv2 describe-target-health --target-group-arn [target-group] | \
jq '[ .TargetHealthDescriptions[]
| select (( .TargetHealth.State == "healthy") and .Target.Id != "'${MYIP}'" )]
| length'`
# Adding 1 to variables to turn string into number
HEALTHNODE=$(($HEALTHNODE+1))
min=$((TotalAcceptableNodes+1))
echo "==== Total nodes online:: ${HEALTHNODE} > ${min} excluding myself ${MYIP} ===="
if [[ ${HEALTHNODE} -lt ${min} ]] ; then
  # If we don't have enough healthy nodes, exit the script and throw a response code != 0
  echo `date` "Stopping command, we don't have enough nodes up and available"  >> /var/log/pegasus/runstacklog/maintenance.html
  exit 599
fi
