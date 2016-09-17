#!/bin/bash

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

scripts=""

if [ -z "$1" ]
then
  for file in `find ./tests -name '*.js'`
  do
    scripts="${scripts};loadScript('$file');"
  done
  echo "Testing all contracts on geth..."
else
  echo "Geth test $1"
  let file="$1"
  file="$(tr '[:lower:]' '[:upper:]' <<< ${file:0:1})${file:1}"
  file+="_test.js"
  scripts="loadScript('tests/$file');"
fi

$geth --exec "$scripts" attach ipc:data/geth.ipc

echo "Done."
