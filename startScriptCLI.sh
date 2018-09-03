#!/bin/bash
 # initialise variables
 optionsArray=(Exit
            Jupyter_Notebook
            Spyder
            Anaconda_Navigator
            Atom
            Firefox
            Chrome
            Terminal)
 functionsArray=(runExitFunction
            runJupyterNotebookFunction
            runSpyderFunction
            runAnacondaNavigatorFunction
            runAtomFunction
            runFirefoxFunction
            runChromeFunction
            runTerminalFunction)
optionsArrayLength=${#optionsArray[@]}

 # prints options menu.
 printMenuFunction(){
 printf "Selection Menu \n\n"
 select opt in "${optionsArray[@]}"
 do
     case $opt in
         "Exit")
           startItemFunction "Exit" "runExitFunction"
 	    ;;
         "Jupyter_Notebook")
            startItemFunction "Jupyter_Notebook" "runJupyterNotebookFunction"
 	    ;;
         "Spyder")
            startItemFunction "Spyder" "runSpyderFunction"
 	    ;;
         "Anaconda_Navigator")
            startItemFunction "Anaconda_Navigator" "runAnacondaNavigatorFunction"
 	    ;;
         "Atom")
            startItemFunction "Atom" "runAtomFunction"
 	    ;;
         "Firefox")
            startItemFunction "Firefox" "runFirefoxFunction"
 	    ;;
         "Chrome")
            startItemFunction "Chrome" "runChromeFunction"
 	    ;;
         "Terminal")
            startItemFunction "Terminal" "runTerminalFunction"
      ;;
         *) echo invalid option;;
     esac
 done

 }
# prints options menu.
 printMenuFunction2(){
  clear
  printf "Selection Menu \n\n"
  # printing the options
  for ((i=0; i<${optionsArrayLength}; i++));
   do
    # selection is only for proper spacing
    if (($i<10));
    then
      printf "Option %s  is %s \n" ${i} ${optionsArray[$i]}
    else
      printf "Option %s is %s \n" ${i} ${optionsArray[$i]}
    fi
   done
   # user input
   while true; do
     read userInput
     # check the provided input
     if ((userInput<=${optionsArrayLength}));
     then
      return $userInput
     else
      printf "Wrong input please try again \n"
     fi
   done

 }

 # starts the selected item and calls the menu again
 startItemFunction(){
 	printf "Starting %s \n\n" $1
  $2
 }
 # items to be started
 runJupyterNotebookFunction(){
     # assuming that anaconda is installed in user home
     cd ~
     cd ./anaconda3/bin
     ./jupyter-notebook & disown
 }
 runTerminalFunction(){
     cd ~
     gnome-terminal & disown
 }
 runSpyderFunction(){
     # assuming that anaconda is installed in user home
     cd ~
     cd ./anaconda3/bin
     ./spyder & disown
 }
 runAnacondaNavigatorFunction(){
     # assuming that anaconda is installed in user home
     cd ~
     cd ./anaconda3/bin
     ./anaconda-navigator & disown
 }
 runAtomFunction(){
 		atom & disown
 }
 runFirefoxFunction(){
 		firefox & disown
 }
 runChromeFunction(){
 		google-chrome & disown
 }
 runExitFunction(){
  exit
 }

 #main execution

 while true; do
  ##original 2 array solution they need to be in proper order though
  #printMenuFunction2
  #user_choise=$?
  #startItemFunction ${optionsArray[$user_choise]} ${functionsArray[$user_choise]}

  # single array design
  printMenuFunction

 done
