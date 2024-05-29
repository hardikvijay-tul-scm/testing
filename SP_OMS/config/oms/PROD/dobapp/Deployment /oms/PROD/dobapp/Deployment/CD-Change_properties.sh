#!/bin/bash -xe


#Update the IP address in runtime-local.properties and jgroups-tcp.xml
internalipaddress=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)


sed -i "s/nodeaddress/$internalipaddress/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
sed -i "s/nodeaddress/$internalipaddress/g" /omsapp/apache-tomcat-7.0.42/bin/catalina.sh

#changing ownership from root to ciadmin
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/bin/catalina.sh
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties

chmod 777 /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
chmod 777 /omsapp/apache-tomcat-7.0.42/bin/catalina.sh
chmod 664 /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties

