#!/bin/bash
echo "starting oms server"
su ciadmin -c 'source /etc/profile; source /home/ciadmin/.bash_profile; cd /omsapp/apache-tomcat-7.0.42/bin; sh startup.sh'

	
