#!/bin/bash


reset_mariacontainer(){
  # mariadb variables
  mariaName="maria" # $1
  mariaPassword="pass" # $2
  mariaEnvironmentPort="3306" # $3
  mariaContainerPort="3306" # $4
  mariaDatabaseName="database" # $5
  # stop and remove container
  sudo docker container stop $mariaName ;
  sudo docker container rm $mariaName ;
  # make new container
  sudo docker run --name $mariaName \
                  --restart always \
                  -e MYSQL_ROOT_PASSWORD=$mariaPassword \
                  -e MYSQL_DATABASE=$mariaDatabaseName \
                  -p $mariaEnvironmentPort:$mariaContainerPort \
                  -d mariadb:10.3.10-bionic

  # wait for container to start
  sleep 10 ;
  sudo docker ps -a ;

  # sudo docker exec -i maria mysql -uroot -ppass ggdm < ../installation/maria_init.sql
}

#################
# main function #
#################
reset_mariacontainer
