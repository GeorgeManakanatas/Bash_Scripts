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
#
# starting environment
#
start_environment(){
  # environment name , environment path from home , project path from home in this order
  environmetPath=$(check4folder $2 "Select the $1 environment bin folder")
  projectPath=$(check4folder $3 "Select the $1 project root folder")
  if [ $environmetPath = "error" ]; then
    notification "Python environment folder not found"
  fi
  if [ $projectPath = "error" ]; then
    notification "Python project folder not found"
  fi

  spd-say "Starting $1 environment"
  cd $environmetPath
  . activate
  cd $projectPath
  gnome-terminal & disown
  exit
}
#
# python projects window function
#
open_python_projects(){
  #zenity anaconda window configuration
  pythonEnvironmentTitle="    Python projects    "
  pythonPrompt="Make your selection"
  pythonWindowHeight=200

  # getting the selected checkboxes
  response=$(zenity --height="$pythonWindowHeight" --list --checklist \
     --title="$pythonEnvironmentTitle" --column="" --column="$pythonPrompt" \
     False "ImageRec project" False "Sound project" False "Django project"\
     --separator=':');

  # check for no selection
  if [ -z "$response" ] ; then
     notification "No selection made"
     #echo "No selection"
     #exit 1
  fi
  # if selection made
  IFS=":" ; for word in $response ; do
     case $word in
        "ImageRec project")
          start_environment "ImageRec" "Documents/python3environments/ImageRecProjectEnvironment/bin" "Documents/projects/ImageRecProject"
          ;;
        "Sound project")
          start_environment "sound" "Documents/python3environments/pythonSoundEnvironment/bin" "Documents/projects/pythonSound"
          ;;
        "Django project")
          start_environment "django" "/not/existant/folder/" "/not/existant/folder/"
          ;;
     esac
  done
}


# actually running
open_python_projects
