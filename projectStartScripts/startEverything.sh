	#!/bin/bash

#### GLOBAL VARIABLES ####

# directory paths
currentFolder=`pwd`
frontendFolder="$currentFolder/front-end"
backendFolder="$currentFolder/back-end"
chromeTempDataDir="$currentFolder/tempDataDir"
# configuration for containers
mongoDockerName="mongo"
elasticDockerName="elasticsearch"
graylogDockerName="graylog"
# behaviour (defines if already existing containers should be removed)
removeContainers=true

#### FUNCTIONS ####

# starting programs
startCromeNoCors(){
  chromium-browser --disable-web-security --user-data-dir=$chromeTempDataDir & disown
}

startpostman(){
  postman & disown
}

openMongoTerminal(){
  gnome-terminal -- bash -c 'mongo' & disown
}

startAtom(){
  sudo atom & disown
}

startSystemMonitor(){
  gnome-system-monitor & disown
}

# application startup
startBackEnd(){
  cd $backendFolder
  gnome-terminal -- bash -c 'npm run start' & disown
  cd $currentFolder
}

startFrontEnd(){
  cd $frontendFolder
  gnome-terminal -- bash -c 'http-server' & disown
  cd $currentFolder
}


#### MAIN ROUTINE ####

sudo echo "root permission required for some"
# run local graylog script
sudo ./graylogDefaultStart.sh
# start various applications
startAtom
startCromeNoCors
startpostman
startSystemMonitor
openMongoTerminal
# start the core program
startBackEnd
startFrontEnd
