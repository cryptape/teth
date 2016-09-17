#!/bin/bash

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

scripts=""

if [ -z "$1" ]
then
  echo "Testing all contracts on geth..."
  for file in `find ./gtests -name '*.js'`
  do
    scripts="${scripts};loadScript('$file');"
  done
else
  file=$1
  file="$(tr '[:lower:]' '[:upper:]' <<< ${file:0:1})${file:1}"
  echo "Testing contract $file..."
  file+="_test.js"
  scripts="loadScript('gtests/$file');"
fi

$geth --exec "$scripts" attach ipc:data/geth.ipc

echo "Done."
