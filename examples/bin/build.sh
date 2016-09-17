#!/bin/bash
if [ -z "$1" ]
then
  echo "Building all contracts ..."
  for sol in `find ./contracts -name '*.sol'`
  do
    echo "Building contract ${sol}"
    let len=${#sol}-16
    jsfile="${sol:12:len}_compiled.js"
    ./bin/solc_helper.rb ${sol} $jsfile
    mv $jsfile builds/
  done
  echo "Done."
else
  sol=$1
  sol="$(tr '[:lower:]' '[:upper:]' <<< ${sol:0:1})${sol:1}"
  echo "Building contract ${sol}"

  file="contracts/${sol}.sol"
  len=${#sol}-16
  jsfile="${sol}_compiled.js"
  ./bin/solc_helper.rb $file $jsfile
  mv $jsfile builds/
  echo "Done."
fi
