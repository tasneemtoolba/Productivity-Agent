const clickContractAddress = '0x67c97D1FB8184F038592b2109F854dfb09C77C75';
const clickContractAbi = [
    {
        type: 'function',
        name: 'click',
        inputs: [],
        outputs: [],
        stateMutability: 'nonpayable',
    },
] as const;

export const calls = [
    {
        address: clickContractAddress,
        abi: clickContractAbi,
        functionName: 'click',
        args: [],
        to: "0xA238Dd80C259a72e81d7e4664a9801593F98d1c5" as `0x${string}`, 
    }
];