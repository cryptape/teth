#!/bin/bash

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

echo "Starting geth attach..."

$geth attach ipc:data/geth.ipc
