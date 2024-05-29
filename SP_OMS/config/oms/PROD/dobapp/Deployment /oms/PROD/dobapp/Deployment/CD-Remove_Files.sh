#!/bin/bash
DESTINATION_DIR_WAR=/omsapp/apache-tomcat-7.0.42/webapps
DESTINATION_DIR_CONF=/omsapp/apache-tomcat-7.0.42/lib
DR_DEST_DIR_WAR=/etappdata/oms-deploy/webapps
DR_DEST_DIR_CONF=/etappdata/oms-deploy/lib

if [ -d /dob_codedeploy ]
then
	rm -rf /dob_codedeploy/*
else
	mkdir /dob_codedeploy
fi
