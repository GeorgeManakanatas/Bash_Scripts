#!/bin/bash

# start redis container
redis_container(){
  # stop existing container
  sudo docker container stop $1
  # remove container
  sudo docker container rm $1
  # reun container
  sudo docker run -d \
  -v $pathToVolume$2redis.conf:/usr/local/etc/redis/redis.conf \
  -v $pathToVolume$2$3:/data \
  -p $4:6379 \
  --name $1 \
  --restart always \
  redis
# -e REDIS_PASSWORD=theredispassword \
# -c "redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}" \
}

pathToVolume="/home/georgemanakanatas/Documents/projects/Bash_Scripts/dockerScripts/"

redis_container "redis_dev" "dev/" "dev_data/" "6383"

sudo chmod -R 777 ./
