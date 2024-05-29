#!/bin/bash
echo "starting pincode server"
su ciadmin -c "nohup java -jar /microapp/microservices/etl_services/ETL-ReverseServiceability.jar --spring.config.location=/microapp/microservices/etl_services/application.properties > /microapp/microservices/etl_services/etl_services.log 2>&1 &"
sleep 60s
echo "Application startup complete"
