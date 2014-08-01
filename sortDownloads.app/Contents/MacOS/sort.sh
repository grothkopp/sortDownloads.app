#!/bin/bash

FILES=~/Downloads/*
DIR=~/Downloads/

for f in $FILES
do
  SRC=$(mdls "$f" -name kMDItemWhereFroms|grep '"'|grep -v '""'|tail -n1|sed 's/^ *//')


  SRC=$(echo "$SRC" |sed 's/^ *"[^\/]*\/\/\([^\/]*\).*$/\1/')
  SRC=$(echo "$SRC" |sed 's/^www.//')

  if [[ "$SRC" != *\(null\)* ]] && [[  "$SRC" != "$f" ]] && [[  -f "$f" ]] && [[ "$SRC" != "" ]] 
  then
  echo "processing $f"
  echo "-$SRC-"

    if [ ! -d "$DIR$SRC" ]; then
      mkdir "$DIR$SRC"
    fi


    file="${f##*/}"
    ext="${file##*.}"
    n="${file%.*}"

    # Check if file exists and rename if necessary
    name="$DIR$SRC/$n"
    if [[ -e $name.$ext ]] ; then
      i=1
      while [[ -e "$name ($i).$ext" ]] ; do
       let i++
      done
      name="$name ($i)"
    fi
    
    mv "$f" "$name.$ext"

    SHORT=$(echo "$f"| sed "s#$HOME##"| sed 's#/Downloads/##')

    # Notification
    osascript -e "display notification \"$SHORT ==>\n$SRC\" with title \"Sort Downloads\""

  fi

done
