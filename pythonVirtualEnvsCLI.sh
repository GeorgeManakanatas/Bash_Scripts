#!/bin/bash
# must be run as source

# old implementation

 PS3 = 'Please the project to work on: '
 options=("OpenCV project" "Django project" "Quit")
 select opt in "${options[@]}"
 do
     case $opt in
         "OpenCV project")
             echo "you chose the OpenCV project"
 	    . Documents/python3environments/OpenCVenvironment/bin/activate
             break
 	    ;;
         "Django project")
             echo "you chose Django project"
 	    . Documents/python3environments/djangoEnvironment/bin/activate
 	    break
             ;;
         "Quit")
             break
             ;;
         *) echo invalid option;;
     esac
 done
