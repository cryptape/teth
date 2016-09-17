#!/bin/bash

geth=${GETH:-geth}

scripts=""

for file in `find ./migrates -name '*.js'`
do
  scripts="${scripts};loadScript('$file')"
done

for file in `find ./tests -name '*.js'`
do
  scripts="${scripts};loadScript('$file');"
done

$geth --exec "$scripts" attach ipc:data/geth.ipc
