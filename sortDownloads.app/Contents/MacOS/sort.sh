#!/bin/bash

FILES=~/Downloads/*
DIR=~/Downloads/

for f in $FILES
do
  SRC=$(mdls "$f" -name kMDItemWhereFroms|tail -n2|head -n1|sed 's/^ *//')

  if [ "$SRC" == '""' ] 
  then
   SRC=$(mdls "$f" -name kMDItemWhereFroms|tail -n3|head -n1)
  fi

  SRC=$(echo "$SRC" |sed 's/^ *".*\/\/\([^\/]*\).*$/\1/')
  SRC=$(echo "$SRC" |sed 's/^www.//')

  if [[ "$SRC" != *\(null\)* ]] && [[  "$SRC" != "$f" ]] && [[  -f "$f" ]]
  then
  echo "processing $f"
  echo "-$SRC-"

    if [ ! -d "$DIR$SRC" ]; then
      mkdir "$DIR$SRC"
    fi
    
    mv "$f" "$DIR$SRC"

    SHORT=$(echo "$f"| sed "s#$HOME##"| sed 's#/Downloads/##')
    osascript -e "display notification \"$SHORT ==>\n$SRC\" with title \"Sort Downloads\""


  fi

done
