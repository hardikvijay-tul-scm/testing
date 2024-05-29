Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash -x

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Update the IP address in runtime-local.properties and jgroups-tcp.xml
internalipaddress=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
jdbc_url="jdbc:oracle:thin:@omsprd.cfceafxhj0x3.ap-south-1.rds.amazonaws.com:1621\/omsprd"
jdbc_username=MPLPRDOMS
jdbc_pwd=Welcome1
deployment="prod"

sed -i "s/nodeaddress/$internalipaddress/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
sed -i "s/nodeaddress/$internalipaddress/g" /omsapp/apache-tomcat-7.0.42/bin/catalina.sh

#Update DB related changes in jgroups-tcp.xml
sed -i "s/dbusername/$jdbc_username/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
sed -i "s/dburl/$jdbc_url/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
sed -i "s/dbpassword/$jdbc_pwd/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml

#Update DB related changes in com.hybris.oms.ext_oms-ext-web.properties
sed -i "s/dbusername/$jdbc_username/g" /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties
sed -i "s/dburl/$jdbc_url/g" /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties
sed -i "s/dbpassword/$jdbc_pwd/g" /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties

#Update property file for DoB
#Update env_type in local.properties
if [ $deployment != 'prod' ]; then
    sed -i "s/DOB_PREPROD2/OMSDOB_$deployment/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
    sed -i "s/DOB_PREPROD2/OMSDOB_$deployment/g" /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties
    sed -i "s/env_type/$deployment/g" /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties
else
    sed -i "s/DOB_PREPROD2/DOB_PROD/g" /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
fi 

#changing ownership from root to ciadmin
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/bin/catalina.sh
chown ciadmin:ciadmin /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties

chmod 777 /omsapp/apache-tomcat-7.0.42/lib/jgroups-tcp.xml
chmod 777 /omsapp/apache-tomcat-7.0.42/bin/catalina.sh
chmod 664 /omsapp/apache-tomcat-7.0.42/lib/org.hybris.dataonboarding_dataonboarding-ext-web.properties

#Clear logs initially
[ -f /omsapp/apache-tomcat-7.0.42/logs/dataonboarding-webapp.log ] && rm /omsapp/apache-tomcat-7.0.42/logs/dataonboarding-webapp.log
[ -f /omsapp/apache-tomcat-7.0.42/logs/catalina.out ] && rm /omsapp/apache-tomcat-7.0.42/logs/catalina.out

if [ $deployment != 'prod' ]; then
    cat /etc/fstab| grep -v '^#' | grep "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_eTAppData"
    if [ $? -ne 0 ]; then
        echo "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_eTAppData /etappdata nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev  0       0" >> /etc/fstab
    fi

    cat /etc/fstab| grep -v '^#' | grep "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_OMS"
    if [ $? -ne 0 ]; then
        echo "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_OMS /oms/pi nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev   0			0" >> /etc/fstab
    fi

    cat /etc/fstab| grep -v '^#' | grep "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_speTAppData/tulincu/www/orderdocs/tmpprod"
    if [ $? -ne 0 ]; then
        echo "fs-3f8152ee.efs.ap-south-1.amazonaws.com:/R2_PPRD_speTAppData/tulincu/www/orderdocs/tmpprod /orderdocs/tmpprod nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev      0       0" >> /etc/fstab
    fi
else
    cat /etc/fstab| grep -v '^#' | grep "10.19.25.148:/PRD_etappdata"
    if [ $? -ne 0 ]; then
        echo "10.19.25.148:/PRD_etappdata /etappdata nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev  0       0" >> /etc/fstab
    fi

    cat /etc/fstab| grep -v '^#' | grep "10.19.25.148:/eTAIL_OMSPI"
    if [ $? -ne 0 ]; then
        echo "10.19.25.148:/eTAIL_OMSPI /oms/pi nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev   0			0" >> /etc/fstab
    fi

    cat /etc/fstab| grep -v '^#' | grep "10.19.25.148:/PRD_spetappdata/tulincu/www/orderdocs/tmpprod"
    if [ $? -ne 0 ]; then
        echo "10.19.25.148:/PRD_spetappdata/tulincu/www/orderdocs/tmpprod /orderdocs/tmpprod nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev  0       0" >> /etc/fstab
    fi

    cat /etc/fstab| grep -v '^#' | grep "10.19.25.148:/eTAIL_FEEDBKP"
    if [ $? -ne 0 ]; then
        echo "10.19.25.148:/eTAIL_FEEDBKP /feedBackup nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev      0       0" >> /etc/fstab
    fi
fi

#Mounting all the required path from EFS
mount -a

chmod 777 /etappdata
chmod 777 /oms
chmod 777 /oms/pi
chmod 777 /orderdocs
chmod 777 /orderdocs/tmpprod

chown ciadmin:ciadmin /etappdata
chown ciadmin:ciadmin /oms
chown ciadmin:ciadmin /oms/pi
chown ciadmin:ciadmin /orderdocs

service codedeploy-agent restart

su ciadmin -c 'source /etc/profile; source /home/ciadmin/.bash_profile; source /home/ciadmin/.bashrc; cd /omsapp/apache-tomcat-7.0.42/bin; sh startup.sh'
