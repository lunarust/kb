# JasperServer Reporting

## Check service health

```bash
/opt/jasperserver/ctlscript.sh status
tomcat already running
postgresql already running

```

- Restart tomcat
```bash
/opt/jasperserver/ctlscript.sh restart tomcat

```

## Logs:

Tomcat: /opt/jasperserver/apache-tomcat/logs/catalina.out
Jasperserver: /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/logs/jasperserver.log


## Change log level for specific libraries:
*requires Jasper server to be restarted
log4j2.properties
aws_mgmt_local/configs/management/states/reporting/jasper/log4j2.properties

## Setup postfix:

File location: /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/js.quartz.properties:

Property example: 
```
report.scheduler.web.deployment.uri=http://reporting01.plop.local:8080/jasperserver-pro

report.scheduler.mail.sender.host=postfix01.plop.local
report.scheduler.mail.sender.username=admin
report.scheduler.mail.sender.password=password
report.scheduler.mail.sender.from=noreply@plop.com
report.scheduler.mail.sender.protocol=smtp
report.scheduler.mail.sender.port=25
```

## LDAP authentication:
File location:
/opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/applicationContext-externalAuth-LDAP.xml

- Setup:

```xml
    <!-- ############ LDAP authentication ############ -->
    <bean id="ldapContextSource" class="com.jaspersoft.jasperserver.api.security.externalAuth.ldap.JSLdapContextSource">
        <constructor-arg value="ldap://ipa.plop.local/dc=plop,dc=local"/>
        <!-- manager user name and password (may not be needed)  -->
        <property name="userDn" value="uid=jasper_ldap,cn=users,cn=accounts,dc=plop,dc=local"/>
        <property name="password" value="MYFANTASTICPASSWORD"/>
    </bean>
    <!-- ############ LDAP authentication ############ -->

```
- Role mapping:

```xml
        <property name="organizationRoleMap">
            <map>
                <!-- Example of mapping customer roles to JRS roles -->
              <entry>
                  <key>
                      <value>ROLE_JASPER_ADMIN</value>
                  </key>
                  <!-- JRS role that the <key> external role is mapped to-->
                  <value>ROLE_ADMINISTRATOR</value>
              </entry>
              <entry>
                  <key>
                      <value>ROLE_JASPER_USER</value>
                  </key>
                  <!-- JRS role that the <key> external role is mapped to-->
                  <value>ROLE_USER</value>
              </entry>
              <entry>
                  <key>
                      <value>ROLE_JASPER_CS</value>
                  </key>
                  <!-- JRS role that the <key> external role is mapped to-->
                  <value>ROLE_CLIENT_SERVICES</value>
              </entry>
              <entry>
                  <key>
                      <value>ROLE_JASPER_FINANCE</value>
                  </key>
                  <!-- JRS role that the <key> external role is mapped to-->
                  <value>ROLE_FINANCE</value>
              </entry>
            </map>
          </property>
```
## Replay a job:
Fetch the Job ID:
```sql
SELECT
label, occurrence_date, trigger_group, job_name, job_group, jb.description, trigger_state, trigger_type, misfire_instr
FROM qrtz_triggers  qt
JOIN JIREPORTJOB jb on id::text = substr(qt.job_name, 5,LENGTH(qt.job_name))
, jilogevent jl where (event_text LIKE '%ReportJobs.' ||  job_name ||'%')
and occurrence_date > now() - interval '7 hours' order by occurrence_date desc
```
Run the following api call:

```bash
curl -X POST http://jasperadmin:MYAWESOMEPASSWORD@localhost:8080/jasperserver/rest_v2/jobs/restart/ \
   -H "Content-Type: application/xml" \
   -H "Accept: application/xml" \
   -d "<jobIdList><jobId>49993</jobId><jobId>000001</jobId></jobIdList>"
```

## Get list of scheduled reports:
```sql
SELECT
to_timestamp(cast(next_fire_time/1000 as bigint)) as next_fire,
to_timestamp(cast(prev_fire_time/1000 as bigint)) as prev_fire,
label,
cron_expression, trigger_state,
report_unit_uri, string_agg(address, ', ')
FROM qrtz_triggers  qt
join qrtz_job_details qjd using (job_name)
LEFT join qrtz_cron_triggers qct on (qt.trigger_name=qct.trigger_name and trigger_type = 'CRON')
LEFT Join qrtz_simple_triggers qst on (qst.trigger_name=qt.trigger_name and trigger_type = 'SIMPLE')
JOIN JIREPORTJOB jb on id::text = substr(qt.job_name, 5,LENGTH(qt.job_name))

LEFT JOIN jireportjobmail jbm on (mail_notification = jbm.id)
LEFT JOIN jireportjobmailrecipient jbr ON (jbr.destination_id = jbm.id)
where trigger_state != 'PAUSED'
GROUP BY 1,2,3,4,5,6
order by 1,3
```

## More
### Setup automatic pipeline to synchronize staging environment to production.

- Get your BI team to alter the reports on a staging environment.
- Set a automatic job to export the reports and push them onto git/BitBucket
- From there, create a routine to import the jobs onto your production environment.

- resources must be present on both environment and use the same naming convention.


> [!NOTE]
> See to add it to ClickBane   
