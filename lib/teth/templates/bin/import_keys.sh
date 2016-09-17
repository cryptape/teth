#!/bin/sh

geth=${GETH:-geth}

echo "***** Using geth at: $geth"

echo "***** Import all pre-funded private keys"

for key in `find ./private_keys -name '*.key'`
do
  echo "Notice: No need to input your password. The default password is 123456"
  ./private_keys/import.sh $key $geth
done

echo "***** Done."
