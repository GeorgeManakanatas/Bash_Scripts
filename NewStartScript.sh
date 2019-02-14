#!/bin/bash

# check that folder exists function
# folder name or path and window text must be provided
check4folder(){
  cd ~ # will look for home by default
  if [ -d "$PWD/$1" ]; then
    echo "$PWD/$1" # if found returns absolute path
  else
    # if not promptsuser to find
    pathToFolder=$(zenity --title="$2" --file-selection --directory )
    # check that user provided path
    if [ -z "$pathToFolder" ]; then
      echo "error" # if no selection return error
    else
      echo "$pathToFolder" # else return asolute path
    fi
  fi
}
# notification function
notification(){
  zenity --notification --window-icon="info" --text="$1" --timeout=2
}
# rabbitmq variables
activemqName="ActiveMQ"
# reset for active container
reset_activemq(){
  spd-say "Resetting active m q container"
  sudo docker rm -f $activemqName
  sudo docker run --name $activemqName -d webcenter/activemq:latest
}
# rabbitmq variables
rabitmqName="RabbitMq"
#  reset for rabbit container
reset_rabbitmq(){
  spd-say "Resetting rabbit m q container"
  sudo docker rm -f $rabitmqName
  sudo docker run --name $rabitmqName -d rabbitmq:3
}
# mariadb variables
mariaName="maria"
mariaPassword="pass"
mariaEnvironmentPort="3306"
mariaContainerPort="3306"
# reset for maria container
reset_maria(){
  spd-say "Resetting maria d b container"
  sudo docker rm -f $mariaName
  sudo docker run --name $mariaName -e MYSQL_ROOT_PASSWORD=$mariaPassword \
    -p $mariaEnvironmentPort:$mariaContainerPort -d mariadb:10.3.10-bionic
}
# mongodb variables
mongoName="mongo"
mongoEnvironmentPort="27017"
mongoContainerPort="27017"
# reset for mongo container
reset_mongo(){
  spd-say "Resetting mongo d b container"
  sudo docker rm -f $mongoName
  sudo docker run --name $mongoName -d mongo:3.6
}
# postgresql variables
postgresContainerName="postgresql"
postgresName="db"
postgresUserName="user"
postgresPassword="pass"
postgresEnvironmentPort="5432"
postgresContainerPort="5432"
# reset for postgresql container
reset_postgresql(){
  spd-say "Resetting post gre s q l container"
  sudo docker rm -f $postgresContainerName ;
  sudo docker run --name $postgresContainerName -e \
  POSTGRESQL_USER=$postgresUserName -e POSTGRESQL_PASSWORD=$postgresPassword \
  -e POSTGRESQL_DATABASE=$postgresName \
  -p $postgresEnvironmentPort:$postgresContainerPort \
  -d centos/postgresql-96-centos7 ;
}
# remove container
remove_container(){
  container=$(zenity --entry --title="Stop Container" --text="Container to stop" );
  spd-say "Removing $container container"
  sudo docker container stop $container
  sudo docker container rm $container
}
#
# terminal window function
#
open_terminals(){
  while response=$(zenity --question \
  --text="Do you want to open a terminal window?" \
  --ok-label="Yes" --cancel-label="No"); do
    if [ $? = 0 ] ; then
      spd-say "Opening new terminal"
      cd ~
      gnome-terminal & disown
    else
      echo "Thank you :)"
      exit
    fi
  done
}

##############################
# containers window function #
##############################
start_containers(){
  #zenity containers configuration
  containersTitle="    Containers    "
  containersPrompt="Make your selection"
  containersWindowHeight=300
  #
  response=$(zenity --height="$containersWindowHeight" --list --checklist \
     --title="$containersTitle" --column="" --column="$containersPrompt" \
     False "RabbitMQ" False "ActiveMQ" False "Postgresql" False "MongoDB" \
     False "MariaDB" False "Show containers" False "Remove Container" --separator=':');

  # check for no selection
  if [ -z "$response" ] ; then
     echo "No selection"
     #exit
  fi

  IFS=":" ; for word in $response ; do
     case $word in
        "RabbitMQ")
          reset_rabbitmq
          notification "RabbitMQ container restarted" ;;
        "ActiveMQ")
          reset_activemq
          notification "ActiveMQ container restarted" ;;
        "Postgresql")
          reset_postgresql
          notification "Postgresql container restarted" ;;
        "MongoDB")
          reset_mongo
          notification "MongoDB container restarted" ;;
        "MariaDB")
          reset_maria
          notification "MariaDB container restarted" ;;
        "Show containers")
          spd-say "Showing containers"
          sudo docker ps -a ;;
        "Remove Container")
          remove_container ;;
     esac
  done
  # Show containers
  sudo docker ps -a
}
#
# browsers window function
#
open_browsers(){
  #zenity configuration
  browsersTitle="    Browsers    "
  browsersPrompt="Make your selection"
  browsersWindowHeight=200
  # getting the selected checkboxes
  response=$(zenity --height="$browsersWindowHeight" --list --checklist \
     --title="$browsersTitle" --column="" --column="$browsersPrompt" \
     False "Chrome" False "Firefox" --separator=':');
  # check for no selection
  if [ -z "$response" ] ; then
     echo "No selection"
     #exit 1
  fi
  # if selection made
  IFS=":" ; for word in $response ; do
     case $word in
        "Chrome")
          spd-say "Starting chrome"
          google-chrome & disown ;;
        "Firefox")
          spd-say "Starting firefox"
          firefox & disown ;;
     esac
  done
}
#
# anaconda window function
#
open_anaconda(){
  #zenity anaconda window configuration
  anacondaTitle="    Anaconda    "
  anacondaPrompt="Make your selection"
  anacondaWindowHeight=300
  # checking that anaconda3/bin is in the system
  absolutePath=$(check4folder "anaconda3/bin" "Select the Anaconda3 bin Folder")
  #
  if [ $absolutePath = "error" ]; then
    # if anaconda not present in the system
    notification "Anaconda not found"
    #echo "Anaconda not found"
  else
    # getting the selected checkboxes
    response=$(zenity --height="$anacondaWindowHeight" --list --checklist \
       --title="$anacondaTitle" --column="" --column="$anacondaPrompt" \
       False "Navigator" False "Spyder" False "Jupyter"  False "Orange" \
       --separator=':');
  fi

  # check for no selection
  if [ -z "$response" ] ; then
     notification "No selection made"
     #echo "No selection"
     #exit 1
  fi
  # if selection made
  IFS=":" ; for word in $response ; do
     case $word in
        "Navigator")
          spd-say "Starting Navigator"
          cd $absolutePath
          ./anaconda-navigator & disown
          notification "Navigator started"
          ;;
        "Spyder")
          spd-say "Starting Spyder"
          cd $absolutePath
          ./spyder & disown
          notification "Spyder started"
          ;;
        "Jupyter_Lab")
          spd-say "Starting Jupyter lab"
          cd $absolutePath
          ./jupyter-lab & disown
          notification "Jupyter-lab started"
          ;;
        "Orange")
          spd-say "Starting Orange"
          cd $absolutePath
          ./orange-canvas & disown
          notification "Orange started"
          ;;
     esac
  done
}


#
# zenity main window configuration
#
mainTitle="New start script"
mainPrompt="Please pick an option"
mainWindowHeight=300
mainOptions=("Docker containers" "Browsers" "Anaconda" "Terminals" "Pyhon projects" "Atom")

while opt=$(zenity --title="$mainTitle" --text="$mainPrompt" \
--height="$mainWindowHeight" --list --column="Options" "${mainOptions[@]}"); do

    case "$opt" in
    "${mainOptions[0]}" )
      start_containers
        ;;
    "${mainOptions[1]}" )
      open_browsers
        ;;
    "${mainOptions[2]}" )
      open_anaconda
        ;;
    "${mainOptions[3]}" )
      open_terminals
        ;;
    "${mainOptions[4]}" )
      # for now I can't run multiple environments from inside this script so I seperated them
      cd ~
      ./Documents/projects/Bash_Scripts/projectStartScripts/pythonVirtualEnvsGUI.sh
        ;;
    "${mainOptions[5]}" )
      spd-say "Opening atom editor"
      atom & disown
        ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done
