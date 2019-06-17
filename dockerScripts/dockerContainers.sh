#!/bin/bash
################
# general info #
################

# General purpose script to make working with containers easyer.

########################
# supporting functions #
########################

# notification function
notification(){
  # will display a notification with given text
  zenity --notification --window-icon="info" --text="$1" --timeout=2
}
reset_activemq(){
  # rabbitmq variables
  activemqName="ActiveMQ"
  #
  sudo docker rm -f $activemqName
  sudo docker run --name $activemqName -d webcenter/activemq:latest
}
reset_rabbitmq(){
  # rabbitmq variables
  rabitmqName="RabbitMq"
  #
  sudo docker rm -f $rabitmqName
  sudo docker run --name $rabitmqName -d rabbitmq:3
}
reset_maria(){
  # mariadb variables
  mariaName="maria"
  mariaPassword="pass"
  mariaEnvironmentPort="3306"
  mariaContainerPort="3306"
  #
  sudo docker rm -f $mariaName
  sudo docker run --name $mariaName -e MYSQL_ROOT_PASSWORD=$mariaPassword -p $mariaEnvironmentPort:$mariaContainerPort -d mariadb:10.3.10-bionic
}
reset_mongo(){
  # mongodb variables
  mongoName="mongo"
  mongoEnvironmentPort="27017"
  mongoContainerPort="27017"
  #
  sudo docker rm -f $mongoName
  sudo docker run --name $mongoName -d mongo:3.6
}
reset_postgresql(){
  # postgresql variables
  postgresContainerName="postgresql"
  postgresName="db"
  postgresUserName="user"
  postgresPassword="pass"
  postgresEnvironmentPort="5432"
  postgresContainerPort="5432"
  #
  sudo docker rm -f $postgresContainerName ;
  sudo docker run --name $postgresContainerName -e POSTGRESQL_USER=$postgresUserName -e POSTGRESQL_PASSWORD=$postgresPassword -e POSTGRESQL_DATABASE=$postgresName -p $postgresEnvironmentPort:$postgresContainerPort -d centos/postgresql-96-centos7 ;
}
# open a terminal
open_terminal(){
  cd ~
  gnome-terminal & disown
}
start_container(){
  # popup for user to give the name of the container to be started and starts it
  container=$(zenity --entry --title="Start Container" --text="Container to start" );
  #
  sudo docker container start $container
}
stop_container(){
  # presents popup for user to give the name of the container to be stoped and stops it
  container=$( zenity --entry --title="Stop Container" --text="Container to Stop" );
  #
  sudo docker container stop $container
}
create_container(){
  # popup to give a port on the host machine to bind the 8443 default of the container
  port=$(zenity --entry --title="Container" --text="Port to assign 8443 to" );
  # popup for the name of the container to be created
  name=$(zenity --entry --title="Container" --text="Name of the container" );
  sudo docker run -p $port:8443 --name $name node_solid_server
}
remove_container(){
  # popup for the user to give the name of the container to be removed
  container=$( zenity --entry --title="Remove Container" --text="Container to remove" );
  # and then proceeds to stop the container and remove it
  sudo docker container stop $container
  sudo docker container rm $container
}
remove_image(){
  # popup for the user to give the name of the image to be removed
  image=$(zenity --entry --title="Remove Image" --text="Image to remove" );
  # and then proceeds to remove iamge
  sudo docker image rm $image
}

###################################
# containers window main function #
###################################
start_menu(){
  #zenity configuration
  title="Node project containers"
  prompt="Please pick a container to run"
  windowHeight=500
  #
  response=$(zenity --height="$windowHeight" --list --checklist \
     --title="$title" --column="" --column="Options" \
     False "RabbitMQ" \
     False "ActiveMQ" \
     False "Postgresql" \
     False "MongoDB" \
     False "MariaDB" \
     False "Show containers" \
     False "Create container" \
     False "Starts container" \
     False "Stop container" \
     False "Remove Container" \
     False "Show Images" \
     False "Remove Image" --separator=':');

  # check for no selection
  if [ -z "$response" ] ; then
     echo "No selection"
     exit 1
  fi

  IFS=":" ; for word in $response ; do
     case $word in
        "RabbitMQ")
          reset_rabbitmq
          notification "RabbitMQ started" ;;
        "ActiveMQ")
          reset_activemq
          notification "ActiveMQ stared" ;;
        "Postgresql")
          reset_postgresql
          notification "PostgreSQL started" ;;
        "MongoDB")
          reset_mongo
          notification "MongoDB started" ;;
        "MariaDB")
          reset_maria
          notification "MariaDB started" ;;
        "Stop Container")
        	stop_container
        	notification "Container stoped" ;;
      	"Start Container")
        	start_container
        	notification "Container started" ;;
        "Create container")
          create_container
          notification "Container created" ;;
        "Show containers")
          sudo docker ps -a ;;
        "Remove Container" )
          remove_container
          notification "Container removed" ;;
        "Show Images")
          sudo docker images ;;
        "Remove Image")
        	remove_image
          notification "Image removed" ;;
     esac
  done
}

# loop ensuring that main window function restarts once task is finished
while true; do
  start_menu
done
