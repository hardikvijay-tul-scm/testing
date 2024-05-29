#!/bin/bash
echo "stopping microservices server"
#su ciadmin -c "sh /microapp/apache-tomcat-8.5.49/bin/shutdown.sh -force"
sleep 10s
PID_Etl=`ps -eaf | grep -i "/microapp/microservices/etl_services/application.properties" | grep -v grep | awk {'print $2'}`
if [[ "" !=  "$PID_Etl" ]]; then
	echo "killing $PID_Etl"
	kill -9 $PID_Etl
else
	echo "etl is not running"
fi
