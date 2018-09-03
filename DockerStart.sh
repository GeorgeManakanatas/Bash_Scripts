#!/bin/bash
# must be run as source

# Starts MongoDB RabbitMQ containers and FrontEnd and BackEnd containters of a MEAN stack project
# Docker files are assumed to be in their respective folders

# general
rabitmqName="myRabbitMq" 
mongoName="mongo"
keystoreFolderPath="/absolute/path/to/file/back-end:/usr/src/app/certs/server"
rabbitKeystoreFolderPath="/absolute/path/to/file/back-end:/usr/src/app/certs/rabbit"
# front end 
frontEndHost="localhost"
frontEndPort="11111" 
frontEndName="frontend"
frontEndEnvFile="./front-end/frontend.env"
frontEndDockerFilePath="./front-end"
# back end
backEndHost="localhost"
backEndPort="11112"
backEndName="backend"
backEndEnvFile="./back-end/backend.env"
backEndDockerFilePath="./back-end"

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
  docker rm -f $mongoName
  docker run --name $mongoName -d --restart always mongo:3.6
}
#docker run -d --hostname my-rabbit --name some-rabbit rabbitmq:3
reset_rabbitmq(){
  docker rm -f $rabitmqName
  docker run --name $rabitmqName -d --restart always rabbitmq:3
}
reset_frontend(){
  docker rm -f $frontEndName
  docker build -t test/frontend $frontEndDockerFilePath
  docker run -d --env-file $frontEndEnvFile -p $frontEndPort:80 --name $frontEndName test/frontend
}
reset_backend(){
  docker rm -f $backEndName
  docker build -t test/backend $backEndDockerFilePath
  docker run -p $backEndPort:8081 -v $keystoreFolderPath -v $rabbitKeystoreFolderPath -d --env-file $backEndEnvFile --link mongo:mongo --name $backEndName test/backend
}
#zenity configuration
title="Node project containers"
prompt="Please pick a container to run"
windowHeight=300
options=("Initialize all" "FrontEnd restart" "BackEnd restart" "Mongo restart" "Rabbit restart" "Show containers")

while opt=$(zenity --title="$title" --text="$prompt" --height="$windowHeight" --list \
                   --column="Options" "${options[@]}"); do

    case "$opt" in
    "${options[0]}" )
      create_env_file $backEndEnvFile $frontEndHost $frontEndPort
      create_env_file $frontEndEnvFile $backEndHost $backEndPort
      reset_mongo
      reset_rabbitmq
      reset_backend
      reset_frontend
        ;;
    "${options[1]}" )
      reset_frontend
        ;;
    "${options[2]}" )
      reset_backend
        ;;
    "${options[3]}" )
      reset_mongo
        ;;
    "${options[4]}" )
      reset_rabbitmq
        ;;
    "${options[5]}" )
      docker ps -a
        ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done
