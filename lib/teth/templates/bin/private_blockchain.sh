#!/bin/bash

geth=${GETH:-geth}

$geth --datadir data --networkid 31415926 --rpc --rpccorsdomain "*" --nodiscover --unlock 3ae88fe370c39384fc16da2c9e768cf5d2495b48 --password <(echo -n 123456)
