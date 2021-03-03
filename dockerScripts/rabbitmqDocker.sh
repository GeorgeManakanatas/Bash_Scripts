#!/bin/bash

# rabbitmq variables
rabitmqName="RabbitMQ"
#
sudo docker rm -f $rabitmqName
sudo docker run --name $rabitmqName -d rabbitmq:3