#! /bin/bash

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

$geth --datadir `pwd`/data init genesis.json
