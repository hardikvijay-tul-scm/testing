#!/bin/bash
echo "stopping oms server"
cd /omsapp/apache-tomcat-7.0.42/bin
su ciadmin -c "sh shutdown.sh"
PID_OMS=`ps -eaf | grep -i "/omsapp/apache-tomcat-7.0.42/conf/logging.properties" | grep -v grep | awk {'print $2'}`
if [[ "" !=  "$PID_OMS" ]]; then
	echo "killing $PID_OMS"
	kill -9 $PID_OMS
else
	echo "tomcat is not running"
fi

	
