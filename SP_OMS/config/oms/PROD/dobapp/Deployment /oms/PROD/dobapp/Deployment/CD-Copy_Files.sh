#!/bin/bash
DESTINATION_DIR_WAR=/omsapp/apache-tomcat-7.0.42/webapps
DESTINATION_DIR_CONF=/omsapp/apache-tomcat-7.0.42/lib
DR_DEST_DIR_WAR=/etappdata/oms-deploy/webapps
DR_DEST_DIR_CONF=/etappdata/oms-deploy/lib

echo "copying files to the destination directory"
echo "**********************"


cd /dob_codedeploy
echo "Removing Files under '$DESTINATION_DIR_WAR ' and '$DESTINATION_DIR_CONF ' directories"
su ciadmin -c "rm -rf $DESTINATION_DIR_WAR/dataonboarding-ext-web*" 
su ciadmin -c "rm -rf $DESTINATION_DIR_CONF/org.hybris.dataonboarding*"
returncode=$? 
if [ $returncode -ne 0 ];then
	echo "Error while removing war and config files from tomcat apache directory"
else
	echo "Sucessfully removed war and config files from tomcat apache directory"
fi
if [ -d $DR_DEST_DIR_WAR ];then
	echo "The /etappdata/oms-deploy/webapps directory is available"
	su ciadmin -c "rm -rf $DR_DEST_DIR_WAR/*.war"
else
	echo "The /etappdata/oms-deploy/webapps directory is not available"
	su ciadmin -c "mkdir -p $DR_DEST_DIR_WAR"
fi
if [ -d $DR_DEST_DIR_CONF ];then
	echo "The /etappdata/oms-deploy/lib directory is available"
	su ciadmin -c "rm -rf $DR_DEST_DIR_CONF/*.properties"
	su ciadmin -c "rm -rf $DR_DEST_DIR_CONF/*.xml"
else
	echo "The /etappdata/oms-deploy/lib directory is not available"
	su ciadmin -c "mkdir -p $DR_DEST_DIR_CONF"
fi
if [ -d "/dob_codedeploy/" ]
then
	echo "Copying .xml file of dataonboarding"
	su ciadmin -c "cp -rfv /dob_codedeploy/org.hybris.dataonboarding*.xml /omsapp/apache-tomcat-7.0.42/lib"
	echo "Copying .properties file of dataonboarding"
	su ciadmin -c "cp -rfv /dob_codedeploy/org.hybris.dataonboarding*.properties /omsapp/apache-tomcat-7.0.42/lib"
	echo "Copying jgroups-tcp.xml file of dataonboarding"
	su ciadmin -c "cp -rfv /dob_codedeploy/jgroups-tcp.xml /omsapp/apache-tomcat-7.0.42/lib"
	echo "Copying catalina.sh"
	su ciadmin -c "cp /oms_codedeploy/catalina.sh /omsapp/apache-tomcat-7.0.42/bin/"
else
	echo "Directory does not exist"
fi

echo "copying war file"
su ciadmin -c "cp /dob_codedeploy/dataonboarding-ext-web.war /omsapp/apache-tomcat-7.0.42/webapps/"
