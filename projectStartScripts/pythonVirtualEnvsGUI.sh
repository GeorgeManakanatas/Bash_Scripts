#!/bin/bash
# must be run as source

title="Python environments"
prompt="Please pick a project to work on"
options=("OpenCV" "Django")

while opt=$(zenity --title="$title" --text="$prompt" --list \
                   --column="Options" "${options[@]}"); do

    case "$opt" in
    "${options[0]}" )
	atom & disown
	firefox & disown
        cd ~
        . Documents/python3environments/OpenCVenvironment/bin/activate
        cd Documents/projects/openCVproject
  gnome-terminal & disown
        ;;
    "${options[1]}" )
	atom & disown
	firefox & disown
        cd ~
        . Documents/python3environments/djangoEnvironment/bin/activate
        cd Documents/projects/djangoBlog
	gnome-terminal & disown
	python manage.py runserver
        ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
    break
done
