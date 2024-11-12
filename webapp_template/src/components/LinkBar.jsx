'use client'
import React from 'react';
import { Flex, HStack, Button, Text, Link, Radio, RadioGroup } from '@chakra-ui/react';
import { useRouter, usePathname } from 'next/navigation';

function LinkBar({focus, setFocus}) {
    const router = useRouter()
    const pathname = usePathname()

    React.useEffect(() => {
        if (focus === 'launch') router.push('/launch');
        else if (focus === 'trade') router.push('/');
      }, [focus]);
    
    return (<><br/>
        <Flex bg='black' width='100%' justify='space-between' borderRadius='md' shadow='lg' align='center' p={2}>
            <RadioGroup onChange={setFocus} value={focus}>
                <HStack>
                    <Radio value='launch'>Launch</Radio>
                    <Radio value='trade'>Trade</Radio>
                </HStack>
            </RadioGroup>
        </Flex>
    </>);
}

export default LinkBar;
