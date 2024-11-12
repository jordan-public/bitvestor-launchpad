#!/bin/sh

set -e

# Run anvil.sh in another shell before running this

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/BitvestmentFactory.s.sol:Deploy --rpc-url "https://bob-sepolia.rpc.gobob.xyz" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -v

./push_artifacts.sh "BitvestmentFactory.s.sol/808813"

# cd web
# npm run build