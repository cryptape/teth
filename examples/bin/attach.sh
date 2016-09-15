#!/bin/bash

geth=${GETH:-geth}
$geth attach ipc:data/geth.ipc
