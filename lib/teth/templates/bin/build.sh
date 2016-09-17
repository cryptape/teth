#!/bin/bash
if [ -z "$1" ]
then
  echo "Build all contracts ..."
  for sol in `find ./contracts -name '*.sol'`
  do
    filename="${sol}"
    echo "Build ${filename}"
    let len=${#filename}-16
    # echo $len
    jsfile="${filename:12:len}_compiled.js"
    echo $jsfile
    ./bin/solc_helper.rb $sol $jsfile
    mv $jsfile builds/
  done
  echo "Done."
else
  foo=$1
  foo="$(tr '[:lower:]' '[:upper:]' <<< ${foo:0:1})${foo:1}"
  sol="contracts/$1.sol"
  filename="${sol}"
  echo "Build ${filename}"
  let len=${#filename}-16
  # echo $len
  jsfile="${foo}_compiled.js"
  echo "Build $foo to $jsfile"
  ./bin/solc_helper.rb $sol $jsfile
  mv $jsfile builds/
  echo "Done."
fi
