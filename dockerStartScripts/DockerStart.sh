#!/bin/bash
# must be run as source

# Starts MongoDB RabbitMQ containers and FrontEnd and BackEnd containters of a MEAN stack project
# Docker files are assumed to be in their respective folders

# general
rabitmqName="myRabbitMq"
mongoName="mongo"
keystoreFolderPath="/absolute/path/to/file/back-end:/usr/src/app/certs/server"
rabbitKeystoreFolderPath="/absolute/path/to/file/back-end:/usr/src/app/certs/rabbit"
# front end variables
frontEndHost="localhost"
frontEndPort="11111"
frontEndName="frontend"
frontEndEnvFile="./front-end/frontend.env"
frontEndDockerFilePath="./front-end"
# back end variables
backEndHost="localhost"
backEndPort="11112"
backEndName="backend"
backEndEnvFile="./back-end/backend.env"
backEndDockerFilePath="./back-end"
# postgresql variables
containerName="postgresql_database"
databaseName="db"
databaseUserName="user"
databasePassword="pass"
environmentPort="127.0.0.1:5432"
containerPort="5432"


# function takes the filepath+filename string host and port as arguments
# so that the front and back end containers know where to find each other

create_env_file(){
  if [ -e $1 ]; then
    rm $1
  fi
  echo "HOST=$2" >> $1
  echo "PORT=$3" >> $1
}
reset_mongo(){
  sudo docker rm -f $mongoName
  sudo docker run --name $mongoName -d --restart always mongo:3.6
}
#docker run -d --hostname my-rabbit --name some-rabbit rabbitmq:3
reset_rabbitmq(){
  sudo docker rm -f $rabitmqName
  sudo docker run --name $rabitmqName -d --restart always rabbitmq:3
}
reset_frontend(){
  sudo docker rm -f $frontEndName
  sudo docker build -t test/frontend $frontEndDockerFilePath
  sudo docker run -d --env-file $frontEndEnvFile -p $frontEndPort:80 --name $frontEndName test/frontend
}
reset_backend(){
  sudo docker rm -f $backEndName
  sudo docker build -t test/backend $backEndDockerFilePath
  sudo docker run -p $backEndPort:8081 -v $keystoreFolderPath -v $rabbitKeystoreFolderPath -d --env-file $backEndEnvFile --link mongo:mongo --name $backEndName test/backend
}
reset_postgresql(){
  sudo docker rm -f $containerName
  sudo docker run -d --name $containerName -e POSTGRESQL_USER=$databaseUserName -e POSTGRESQL_PASSWORD=$databasePassword -e POSTGRESQL_DATABASE=$databaseName -p $environmentPort:$containerPort centos/postgresql-96-centos7
}
remove_container(){
  container=$(zenity --entry --title="Stop Container" --text="Container to stop" );
  sudo docker container stop $container
  sudo docker container rm $container
}
#zenity configuration
title="Node project containers"
prompt="Please pick a container to run"
windowHeight=350
options=("Initialize all" "FrontEnd restart" "BackEnd restart" "Mongo restart" "Rabbit restart" "Show containers" "Postgresql" "Remove Container")

while opt=$(zenity --title="$title" --text="$prompt" --height="$windowHeight" --list \
                   --column="Options" "${options[@]}"); do

    IFS=":" ; for word in $opt ; do
      case "$opt" in
      "Initialize all" )
        create_env_file $backEndEnvFile $frontEndHost $frontEndPort
        create_env_file $frontEndEnvFile $backEndHost $backEndPort
        reset_mongo
        reset_rabbitmq
        reset_backend
        reset_frontend
          ;;
      "FrontEnd restart" )
        reset_frontend
          ;;
      "BackEnd restart" )
        reset_backend
          ;;
      "Mongo restart" )
        reset_mongo
          ;;
      "Rabbit restart" )
        reset_rabbitmq
          ;;
      "Show containers" )
        sudo docker ps -a
          ;;
      "Postgresql" )
        reset_postgresql
          ;;
      "Remove Container" )
        remove_container
          ;;
      *) zenity --error --text="Invalid option. Try another one.";;
      esac
    done
done
