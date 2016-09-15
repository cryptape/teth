#!/bin/bash

geth=${GETH:-geth}

scripts=""

for file in `find ./builds -name '*compiled.js'`
do
  scripts="${scripts};loadScript('$file')"
done

for file in `find ./test -name '*.js'`
do
  scripts="${scripts};loadScript('$file');"
done

echo $scripts
$geth --datadir data --networkid 31415926 --rpc --rpccorsdomain "*" --nodiscover --unlock 3ae88fe370c39384fc16da2c9e768cf5d2495b48 --password <(echo -n 123456) --exec "$scripts" console 2>> ./logfile

