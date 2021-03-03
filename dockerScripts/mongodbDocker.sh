#!/bin/bash

# mongodb variables
mongoName="mongo"
mongoEnvironmentPort="27017"
mongoContainerPort="27017"
#
sudo docker rm -f $mongoName
sudo docker run --name $mongoName -d mongo:3.6