#!/bin/bash

######################
#  Common variables  #
######################

currentFolder=`pwd`
# configuration
mongoName="mongo"
elasticName="elasticsearch"
grayName="graylog"
# behaviour
removeContainers=true
global_pid=0
###############
#  Functions  #
###############

display_loading(){
  zenity --text-info --title="$1" --width="245" --height="185" --html --filename=loading_html.txt &
  PID_ZENITY=${!}
  global_pid=$PID_ZENITY
}

graylog_mongo(){
  # stop and remove container if there and removeContainers set to true
  if [ removeContainers ] ; then
    sudo docker container stop $mongoName
    sudo docker container rm $mongoName
  fi
  # running container
  sudo docker run --name $mongoName -d mongo:3 &
  #
  display_loading "Starting $mongoName Docker"
  # wait for mongo
  until [ "`sudo docker inspect -f {{.State.Running}} $mongoName`" == "true" ]; do
    sleep 10;
  done
  # kill loading gif
  kill $global_pid
  # notify
  spd-say "Mongo D B container running"
}

graylog_elasticsearch(){
  # stop and remove container if there and removeContainers set to true
  if [ removeContainers ] ; then
    sudo docker container stop $elasticName
    sudo docker container rm $elasticName
  fi
  #
  sudo docker run --name $elasticName \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.4.3 &
  # wait for elasticsearch
  display_loading "Starting $elasticName Docker"
  #
  until [ "`sudo docker inspect -f {{.State.Running}} $elasticName`" == "true" ]; do
    sleep 10;
  done
  # kill loading gif
  kill $global_pid
  # notify
  spd-say "elastic search container running"
}

graylog(){
  # stop and remove container if there and removeContainers set to true
  if [ removeContainers ] ; then
    sudo docker container stop $grayName
    sudo docker container rm $grayName
  fi
  #
  sudo docker run --name $grayName --link $mongoName --link $elasticName \
    -p 9000:9000 -p 12201:12201 -p 1514:1514 \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://127.0.0.1:9000/" \
    -d graylog/graylog:3.0 &
  # wait for graylog
  display_loading "Starting $grayName Docker"
  #
  until [ "`sudo docker inspect -f {{.State.Health.Status}} $grayName`" == "healthy" ]; do
    sleep 10;
  done
  # kill loading gif
  kill $global_pid
  # notify
  spd-say "Grey log container running"
}


##################
#  Main section  #
##################
# run mongo
graylog_mongo
# run elasticsearch
graylog_elasticsearch
# run graylog
graylog
# show the results
sudo docker ps -a 
