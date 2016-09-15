#!/bin/bash
for sol in `find ./contracts -name '*.sol'`
do
  filename="${sol}"
  echo $filename
  let len=${#filename}-16
  # echo $len
  jsfile="${filename:12:len}_compiled.js"
  echo $jsfile
  ./bin/solc_helper.rb $sol $jsfile
  mv $jsfile builds/
done
