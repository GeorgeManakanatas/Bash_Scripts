#!/bin/bash

######################
#  Common variables  #
######################
# configuration
mongoName="mongo"
elasticName="elasticsearch"
grayName="graylog"
# behaviour
removeContainers=true

###############
#  Functions  #
###############

notification(){
  # will display a notification with given text
  zenity --notification --window-icon="info" --text="$1" --timeout=2
}

graylog_mongo(){
  # stop and remove container if there and removeContainers set to true
  if [ removeContainers ] ; then
    sudo docker container stop $mongoName
    sudo docker container rm $mongoName
  fi
  # running container
  sudo docker run --name $mongoName -d mongo:3 &
  # wait for mongo
  until [ "`sudo docker inspect -f {{.State.Running}} $mongoName`" == "true" ]; do
    echo "zzzzzz  waiting on mongo zzzzzz"
    sleep 0.1;
  done
  # notify
  notification "Mongo running !!!"
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
  echo =====$elasticName=====
  until [ "`sudo docker inspect -f {{.State.Running}} $elasticName`" == "true" ]; do
    echo "zzzzzz  waiting on elastic zzzzzz"
    sleep 0.1;
  done
  # notify
  notification "Elastic search running !!!"
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
  until [ "`sudo docker inspect -f {{.State.Health.Status}} $grayName`" == "healthy" ]; do
    echo "zzzzzz  waiting on graylog zzzzzz"
    sleep 1;
  done
  # finish
  notification "Gaylog running !!!"
}


##################
#  Main section  #
##################
# sudo docker container rm -f $mongoName
# sudo docker container rm -f $elasticName
# sudo docker container rm -f $grayName
# run mongo
graylog_mongo
# run elasticsearch
graylog_elasticsearch
# run graylog
graylog
