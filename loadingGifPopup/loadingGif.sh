#!/bin/bash

global_pid_variable=0

###############
#  Functions  #
###############

display_loading(){
  zenity --text-info --title="$1" --width="245" --height="185" --html --filename=loading_html.txt &

  global_pid_variable=${!}
}

##################
#  Main section  #
##################

display_loading "loading screen"
sleep 10
kill $global_pid_variable
