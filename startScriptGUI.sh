#!/bin/bash

title="Start menu"
text="Please pick an application to run"
errormsg="Invalid option. Try another again."
options=("Chrome" "Firefox" "Atom" "Spyder" "Jupyter" "Navigator" "Terminal")
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
        # assuming that anaconda is installed in user home
        cd ~
        cd ./anaconda3/bin
				./spyder & disown
        ;;
		"${options[4]}" )
        # assuming that anaconda is installed in user home
        cd ~
        cd ./anaconda3/bin
		    ./jupyter-notebook & disown
        ;;
		"${options[5]}" )
        # assuming that anaconda is installed in user home
        cd ~
        cd ./anaconda3/bin
				./anaconda-navigator & disown
        ;;
    "${options[6]}" )
        cd ~
        gnome-terminal & disown
        ;;
    *) zenity --error --text=$errormsg;;
    esac
done
