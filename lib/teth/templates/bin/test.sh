#!/bin/bash

geth=${GETH:-geth}

scripts=""

if [ -z "$1" ]
then
  for file in `find ./tests -name '*.js'`
  do
    scripts="${scripts};loadScript('$file');"
  done
  echo "Geth test all contracts ..."
else
  file="$1"
  file="$(tr '[:lower:]' '[:upper:]' <<< ${file:0:1})${file:1}"
  file+="_test.js"
  scripts="loadScript('tests/$file');"
  echo "Geth test $1"
fi

$geth --exec "$scripts" attach ipc:data/geth.ipc
