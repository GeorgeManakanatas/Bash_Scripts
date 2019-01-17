		#!/bin/bash

		title="Node project start menu"
		text="Please pick an application to run"
		errormsg="Invalid option. Try another again."
		options=("Chrome" "Firefox" "Atom" "MongoBD" "development BackEnd" "testing BackEnd" "Frontend")
		windowHeight=600
		while opt=$(zenity --title="$title" --text="$text" --height=$windowHeight --list \
		                   --column="Options" "${options[@]}"); do

		    case "$opt" in
		    "${options[0]}" )
						google-chrome & disown
		        ;;
		    "${options[1]}" )
						firefox & disown
		        ;;
		    "${options[2]}" )
						atom & disown
		        ;;
		    "${options[3]}" )
						gnome-terminal -x bash -c \"mongo\" & disown
		        ;;
		    "${options[4]}" )
					  cd ~
					  cd ./Documents/projects/Webpage/backEnd
					  gnome-terminal -x bash -c "npm run-script developmentBackEnd" & disown
		        ;;
				"${options[5]}" )
						cd ~
				    cd ./Documents/projects/Webpage/backEnd
					  gnome-terminal -x bash -c "npm run-script testingBackEnd" & disown
		        ;;
		    "${options[6]}" )
						cd ~
						cd ./Documents/projects/Webpage/frontEnd
						gnome-terminal -x bash -c "http-server" & disown
						;;
		    esac
		done
