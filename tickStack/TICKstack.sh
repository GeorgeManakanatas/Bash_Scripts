#!/bin/bash


Start_influxdb(){
    influxdbName="influxdb_default"
    influxdbEnvironmentPort="8086"
    influxdbContainerPort="8086"
    #
    # docker pull influxdb
    #
    sudo docker container rm $influxdbName
    export INFLUX_TOKEN=3FS1g-f5gnnkDVdbk4JdRRrRUh_jUPJfXcmwTJoIiTaUncydej6DMDaEze_xAOpP_uCLExjKITCglxnCELBFXg==
    sudo docker run -d -p $influxdbEnvironmentPort:$influxdbContainerPort \
                    --name $influxdbName \
                    -v $PWD/influx/influxdb.conf:/etc/influxdb/influxdb.conf \
                    influxdb
    # sudo docker run --name $influxdbName\
    #                 -p $influxdbEnvironmentPort:$influxdbContainerPort \
    #                 -d influxdb
};
Start_kapacitor(){
    kapacitorName="kapacitor_default"
    kapacitorEnvironmentPort="9092"
    kapacitorContainerPort="9092"
    #
    # docker pull kapacitor
    #
    sudo docker container rm $kapacitorName
    sudo docker run --name $kapacitorName \
                    -p $kapacitorEnvironmentPort:$kapacitorContainerPort \
                    -v $PWD/kapacitor/kapacitor.conf:/etc/kapacitor/kapacitor.conf
                    -d kapacitor
};
Start_telegraf(){
    telegrafName="telegraf_default"
    # 
    # docker pull telegraf
    #
    sudo docker container rm $telegrafName
    # 
    sudo docker run -d  --name=$telegrafName \
                        -e HOST_PROC=/host/proc \
                        -v /proc:/host/proc:ro \
                        -v $PWD/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
                        telegraf
    # sudo docker exec -it $telegrafName telegraf --config http://localhost:8086/api/v2/telegrafs/072dba49c0bde000

};
Start_chronograf(){
    chronografName="chronograf_default"
    chronografEnvironmentPort="8888"
    chronografContainerPort="8888"
    #
    docker pull chronograf
    #
    sudo docker run --name $chronografName \
                    -p $chronografEnvironmentPort:$chronografContainerPort \
                    -d chronograf
};
Start_entire_stack(){
    Start_influxdb
    Start_kapacitor
    Start_telegraf
    Start_chronograf
};
#
notification(){
  # will display a notification with given text
  zenity --notification --window-icon="info" --text="$1" --timeout=2
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
# zenity main window configuration
#
#zenity configuration
title="TICK stack"
prompt="Choose one or more options"
windowHeight=350
options=(   "Start entire stack" \
            "Start influxdb" \
            "Start kapacitor" \
            "Start telegraf" \
            "Start chronograf" \
            "Show containers" \
            "Stop Container" \
            "Start Container" \
            "Show Images" \
            "Remove Image" \
            "")

while opt=$(zenity --title="$title" --text="$prompt" --height="$windowHeight"\
  --list --column="Options" "${options[@]}"); do

    IFS=":" ; for word in $opt ; do
        case "$opt" in
        "Start entire stack" )
            Start_entire_stack
            ;;
        "Start influxdb" )
            Start_influxdb
            ;;
        "Start kapacitor" )
            Start_kapacitor
            ;;
        "Start telegraf" )
            Start_telegraf
            ;;
        "Start chronograf" )
            Start_chronograf
            ;;
        "Show containers" )
            sudo docker container ls -a ;;
        "Stop Container")
            stop_container
            notification "Container stoped" ;;
        "Start Container")
            start_container
            notification "Container started" ;;
        "Remove Container" )
            remove_container
            notification "Container removed" ;;
        "Show Images")
            sudo docker images ;;
        "Remove Image")
        	remove_image
            notification "Image removed" ;;
      *) zenity --error --text="Invalid option. Try another one.";;
      esac
    done
done


# export INFLUX_TOKEN=DENL5nCHVAFSEpaWVL5CyVzfd87OqSyImZ9wfAnj1ddAP7T9NIdBmyhW_SG6IdSLp5vtYYTzmIYeqOcPmebHCw==
# telegraf --config http://localhost:8086/api/v2/telegrafs/072db05f41265000