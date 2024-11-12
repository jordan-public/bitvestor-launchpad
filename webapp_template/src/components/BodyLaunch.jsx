'use client'
import React from 'react';
import { Heading, FormControl, FormLabel, Select, Textarea, Text, VStack, HStack, Input, Button, Box, Checkbox } from '@chakra-ui/react';
import { ethers } from 'ethers';
import aBitvestmentFactory from '../artifacts/BitvestmentFactory.json';
import aIBitvestment from '../artifacts/IBitvestment.json';
import OnChainContext from './OnChainContext';
import {bigIntToDecimal, decimalToBigInt} from '../utils/decimal';

function multiplyFloatByBigInt(floatNumber, bigIntMultiplier) {
    const [integerPart, fractionalPart] = floatNumber.toString().split('.');
  
    // Convert integer part to BigInt
    const integerPartBigInt = BigInt(integerPart);
  
    // Calculate the fractional part as BigInt
    const fractionalMultiplier = BigInt(10 ** fractionalPart.length);
    const fractionalPartBigInt = BigInt(fractionalPart) * bigIntMultiplier / fractionalMultiplier;
  
    // Multiply integer part by bigIntMultiplier
    const integerResult = integerPartBigInt * bigIntMultiplier;
  
    // Sum the integer and fractional results
    const result = integerResult + fractionalPartBigInt;
  
    return result;
}

  function BodyLaunch({ signer, address, nativeSymbol }) {
    const [onChainInfo, setOnChainInfo] = React.useState({})
    const [price, setPrice] = React.useState(0.001)
    const [symbol, setSymbol] = React.useState('')
    const [name, setName] = React.useState('')
    const [supply, setSupply] = React.useState(0n)
    const [token, setToken] = React.useState('')

    React.useEffect(() => {
        if (!signer) return;
        (async () => {
            const cBitvestmentFactory = new ethers.Contract(aBitvestmentFactory.contractAddress, aBitvestmentFactory.abi, signer);
            setOnChainInfo({signer: signer, address: address, cBitvestmentFactory: cBitvestmentFactory });
        }) ();
    }, [signer, address]);

    const onLaunch = async () => {
        try{
            const tx = await onChainInfo.cBitvestmentFactory.createBitvestment(name, symbol, supply, price)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
            const l = await onChainInfo.cBitvestmentFactory.lastBitvestment();
            const cIBvt = new ethers.Contract(l, aIBitvestment.abi, signer);
            const tokenAddress = await cIBvt.token();
console.log("lastToken", tokenAddress)
            setToken(tokenAddress); // !!! Not safe - others may create tokens in the meantime
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    if (!signer) return(<><br/>Please connect!</>)
    if (!onChainInfo.cBitvestmentFactory) return("Please wait...")
    return (<OnChainContext.Provider value={onChainInfo} >
        <VStack width='70%' p={4} align='center' borderRadius='md' shadow='lg' bg='black'>
            <Heading as="h3" size="md">Price for Launched Token</Heading>
            <FormControl>
                <FormLabel>Token Symbol</FormLabel>
                <Input value={symbol} onChange={e => setSymbol(e.target.value)} />
            </FormControl>
            <FormControl>
                <FormLabel>Token Name</FormLabel>
                <Input value={name} onChange={e => setName(e.target.value)} />
            </FormControl>
            <FormControl>
                <FormLabel>Supply Amount</FormLabel>
                <Input value={bigIntToDecimal(supply).toString()} onChange={e => setSupply(decimalToBigInt(e.target.value))} type='number' />
            </FormControl>
            <FormControl>
                <FormLabel>Token Price ({nativeSymbol})</FormLabel>
                <Input value={bigIntToDecimal(price).toString()} onChange={e => setPrice(decimalToBigInt(e.target.value))} type='number' />
            </FormControl>
            <Button color='black' bg='red' size='lg' onClick={onLaunch}>Launch</Button>
        </VStack>
        <Text>Last Token Address: {token}</Text>
    </OnChainContext.Provider>);
}

export default BodyLaunch;