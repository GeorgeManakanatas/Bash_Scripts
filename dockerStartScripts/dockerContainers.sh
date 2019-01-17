#!/bin/bash

# rabbitmq variables
activemqName="ActiveMQ"
#
reset_activemq(){
  docker rm -f $activemqName
  docker run --name $activemqName -d webcenter/activemq:latest
}
# rabbitmq variables
rabitmqName="RabbitMq"
#
reset_rabbitmq(){
  docker rm -f $rabitmqName
  docker run --name $rabitmqName -d rabbitmq:3
}
# mariadb variables
mariaName="maria"
mariaPassword="pass"
mariaEnvironmentPort="3306"
mariaContainerPort="3306"
#
reset_maria(){
  docker rm -f $mariaName
  docker run --name $mariaName -e MYSQL_ROOT_PASSWORD=$mariaPassword -p $mariaEnvironmentPort:$mariaContainerPort -d mariadb:10.3.10-bionic
}
# mongodb variables
mongoName="mongo"
mongoEnvironmentPort="27017"
mongoContainerPort="27017"
#
reset_mongo(){
  docker rm -f $mongoName
  docker run --name $mongoName -d mongo:3.6
}
# postgresql variables
postgresContainerName="postgresql"
postgresName="db"
postgresUserName="user"
postgresPassword="pass"
postgresEnvironmentPort="5432"
postgresContainerPort="5432"
#
reset_postgresql(){
  docker rm -f $postgresContainerName ;
  docker run --name $postgresContainerName -e POSTGRESQL_USER=$postgresUserName -e POSTGRESQL_PASSWORD=$postgresPassword -e POSTGRESQL_DATABASE=$postgresName -p $postgresEnvironmentPort:$postgresContainerPort -d centos/postgresql-96-centos7 ;
}
# open a terminal
open_terminal(){
  cd ~
  gnome-terminal & disown
}
#zenity configuration
title="Node project containers"
prompt="Please pick a container to run"
windowHeight=300
#
response=$(zenity --height="$windowHeight" --list --checklist \
   --title="$title" --column="" --column="Options" \
   False "RabbitMQ" False "ActiveMQ" False "Postgresql" False "MongoDB" False "MariaDB" --separator=':');

# check for no selection
if [ -z "$response" ] ; then
   echo "No selection"
   exit 1
fi

IFS=":" ; for word in $response ; do
   case $word in
      "RabbitMQ")
        reset_rabbitmq ;;
      "ActiveMQ")
        reset_activemq ;;
      "Postgresql")
        reset_postgresql ;;
      "MongoDB")
        reset_mongo ;;
      "MariaDB")
        reset_maria ;;
   esac
done
# Show containers
docker ps -a
