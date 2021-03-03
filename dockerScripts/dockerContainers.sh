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
  ./dockerScripts/activemqDocker.sh
}
RabbitMQ(){
  ./dockerScripts/rabbitmqDocker.sh
}
MongoDB(){
  ./dockerScripts/mongodbDocker.sh
}
MariaDB(){
  ./dockerScripts/mariaDocker.sh
}
postgreSQL(){
  ./dockerScripts/postgresqlDocker.sh
}
RedisDB(){
  ./dockerScripts/redisDocker.sh
}
start_container(){
  # popup for user to give the name of the container to be started and starts it
  container=$(zenity --entry --title="Start Container" --text="Container to start" );
  sudo docker container start $container
}
stop_container(){
  # presents popup for user to give the name of the container to be stoped and stops it
  container=$(zenity --entry --title="Stop Container" --text="Container to stop" );
  sudo docker container stop $container
}
create_container(){
  # popup to give a port on the host machine to bind the 8443 default of the container
  internalPort=$(zenity --entry --title="Internal Port" --text="Assign internal port to" );
  externalPort=$(zenity --entry --title="External port" --text="Assign external port to" );
  # popup for the name of the container to be created
  containerName=$(zenity --entry --title="Container" --text="Name of the container" );
  #
  imageName=$(zenity --entry --title="Container" --text="Name of the image to create from" );
  sudo docker run -p $internalPort:$externalPort --name $containerName $imageName
}
remove_container(){
  # popup for the user to give the name of the container to be removed
  container=$(zenity --entry --title="Remove Container" --text="Container to remove" );
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
  title="Container Options"
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
     False "RedisDB" \
     False "Show Containers" \
     False "Start Container" \
     False "Stop Container" \
     False "Create Container" \
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
          RabbitMQ
          notification "RabbitMQ started" ;;
        "ActiveMQ")
          reset_activemq
          notification "ActiveMQ stared" ;;
        "Postgresql")
          postgreSQL
          notification "PostgreSQL started" ;;
        "MongoDB")
          MongoDB
          notification "MongoDB started" ;;
        "MariaDB")
          MariaDB
          notification "MariaDB started" ;;
        "RedisDB")
          RedisDB
          notification "RedisDB started" ;;
        "Stop Container")
        	stop_container
        	notification "Container stoped" ;;
      	"Start Container")
        	start_container
        	notification "Container started" ;;
        "Create Container")
          create_container
          notification "Container created" ;;
        "Show Containers")
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
