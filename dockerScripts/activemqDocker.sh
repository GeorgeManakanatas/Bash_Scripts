#!/bin/bash

# activemq variables
activemqName="ActiveMQ"
#
sudo docker rm -f $activemqName
sudo docker run --name $activemqName -d webcenter/activemq:latest