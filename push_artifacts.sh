#!/bin/sh

# Usage: ./push_artifacts.sh <chain_id>

rm webapp_template/src/artifacts/*.json

# Ignore errors
for dirname in out/*.sol; do
    cat $dirname/$(basename "$dirname" .sol).json | jq '{abi: .abi}' > webapp_template/src/artifacts/$(basename "$dirname" .sol).json
done

cat broadcast/$1/run-latest.json out/BitvestmentFactory.sol/BitvestmentFactory.json | \
jq -s \
    'add | 
    { chain: .chain} * (.transactions[] |
    { transactionType, contractName, contractAddress } |
    select(.transactionType == "CREATE" and .contractName == "BitvestmentFactory") |
    {contractName, contractAddress}) * {abi: .abi}' > webapp_template/src/artifacts/BitvestmentFactory.json
