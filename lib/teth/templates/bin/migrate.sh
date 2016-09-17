#!/bin/bash

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

if [ -z "$1" ]
then
  let scripts=""
  for file in `find ./builds -name '*compiled.js'`
  do
    scripts="${scripts};loadScript('$file')"
  done
  scripts="${scripts};miner.start();admin.sleepBlocks(2);miner.stop()"
  $geth --exec "$scripts" attach ipc:data/geth.ipc
else
  let file=$1
  file="$(tr '[:lower:]' '[:upper:]' <<< ${file:0:1})${file:1}"
  file+="_compiled.js"
  $geth --exec "loadScript('builds/$file');miner.start();admin.sleepBlocks(2);miner.stop()" attach ipc:data/geth.ipc
fi

echo "Done."
