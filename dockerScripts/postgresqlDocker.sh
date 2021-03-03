#!/bin/bash

reset_postgresql(){
  # postgresql variables
  postgresContainerName="postgresql"
  postgresName="db"
  postgresUserName="user"
  postgresPassword="pass"
  postgresEnvironmentPort="5432"
  postgresContainerPort="5432"
  # stop remove and make new container
  sudo docker container stop $postgresContainerName ;
  sudo docker container rm $postgresContainerName ;

  sudo docker run --name $postgresContainerName \
                  --restart always \
                  -e POSTGRESQL_USER=$postgresUserName \
                  -e POSTGRESQL_PASSWORD=$postgresPassword \
                  -e POSTGRESQL_DATABASE=$postgresName \
                  -p $postgresEnvironmentPort:$postgresContainerPort \
                  -d centos/postgresql-96-centos7 ;
  # wait for container to start
  sleep 10 ;
  sudo docker ps -a ;
}

#################
# main function #
#################
reset_postgresql
