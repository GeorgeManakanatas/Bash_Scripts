#!/bin/bash

## Supporting functions ##

# should get title and text in that order
question(){
  zenity --question --width=300 --title=$1 --text="$2"
  echo "$?"
}

# should get the path to the folder and the file name in that order
check_for_file(){
  if [ -e "$1/$2" ]; then
    # if the file exists as if it is to be replaced.
    replace=$(question "Replace" "$2 exists in \n\n$1 \n\nReplace?")
    if [ $replace == 0 ]; then
      # delete and replace
      rm $1/$2
      generate_readme_file "$1" "$2"
    else
      # do nothing on no and timeout
      echo "skipping"
    fi
  else
    # if the file does not exist create one
    generate_readme_file "$1" "$2"
  fi
}

generate_readme_file(){
  cd $1
  echo "# ${PWD##*/}" >> $1/$2
  echo "Auto generated readme file" >> $1/$2
  echo "" >> $1/$2
  echo "## Tree structure" >> $1/$2
  echo "" >> $1/$2
  echo "\`\`\`" >> $1/$2
  tree -L 1 >> $1/$2
  echo "\`\`\`" >> $1/$2
  echo "" >> $1/$2
  echo "More stuff under the structure" >> $1/$2
}

##  Main section  ##

filename="README.md"
pathToFolder=$(zenity --title="Select Root Folder" --file-selection --directory )
# check that a path has been provided
if [ ${#pathToFolder} -ne 0 ]; then

  # for the root directory
  check_for_file "$pathToFolder/" "$filename"
  # for the subdirectories
  for d in $pathToFolder/*; do
    if [ -d "$d" ]; then
      check_for_file "$d" "$filename"
    fi
  done

fi
