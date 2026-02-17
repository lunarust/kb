#!/bin/bash
GITPASSWORD=$(/usr/local/bin/aws --region=eu-west-1 ssm get-parameter --name "/environment/GIT-USER-at-1111111111111-Password" --with-decryption --output text --query Parameter.Value)
cd /srv/jasper_reports
git pull https://GIT-USER-at-111111111:$GITPASSWORD@git-codecommit.eu-west-1.amazonaws.com/v1/repos/jasper_reports
