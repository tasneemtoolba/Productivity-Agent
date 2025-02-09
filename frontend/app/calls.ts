const clickContractAddress = '0x58944BCE9ccbd9C512c61CAab35fD4C892793bB1';
const clickContractAbi = [

    // {
    //     type: 'function',
    //     name: 'click',
    //     inputs: [],
    //     outputs: [],
    //     stateMutability: 'nonpayable',
    // },
    {
        type: 'constructor',
        inputs: [
            {
                name: '_addressProvider',
                type: 'address',
                internalType: 'address'
            },
            { name: '_usdcToken', type: 'address', internalType: 'address' },
            { name: '_aUsdcToken', type: 'address', internalType: 'address' }
        ],
        stateMutability: 'nonpayable'
    },
    { type: 'receive', stateMutability: 'payable' },
    {
        type: 'function',
        name: 'ADDRESSES_PROVIDER',
        inputs: [],
        outputs: [
            {
                name: '',
                type: 'address',
                internalType: 'contract IPoolAddressesProvider'
            }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'POOL',
        inputs: [],
        outputs: [
            { name: '', type: 'address', internalType: 'contract IPool' }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'aUsdcToken',
        inputs: [],
        outputs: [
            { name: '', type: 'address', internalType: 'contract IERC20' }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'allowance',
        inputs: [
            { name: 'owner', type: 'address', internalType: 'address' },
            { name: 'spender', type: 'address', internalType: 'address' }
        ],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'approve',
        inputs: [
            { name: 'spender', type: 'address', internalType: 'address' },
            { name: 'value', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [{ name: '', type: 'bool', internalType: 'bool' }],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'balanceOf',
        inputs: [
            { name: 'account', type: 'address', internalType: 'address' }
        ],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'calculateRewards',
        inputs: [
            { name: '_user', type: 'address', internalType: 'address' }
        ],
        outputs: [
            {
                name: '_userRewards',
                type: 'uint256',
                internalType: 'uint256'
            },
            { name: '_daoRewards', type: 'uint256', internalType: 'uint256' }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'claimDAOReward',
        inputs: [],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'claimUserRewards',
        inputs: [
            { name: '_user', type: 'address', internalType: 'address' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'claimedRewards',
        inputs: [{ name: '', type: 'address', internalType: 'address' }],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'daoRewards',
        inputs: [],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'decimals',
        inputs: [],
        outputs: [{ name: '', type: 'uint8', internalType: 'uint8' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'deposit',
        inputs: [
            { name: '_amount', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'execute',
        inputs: [
            { name: 'to', type: 'address', internalType: 'address' },
            { name: 'value', type: 'uint256', internalType: 'uint256' },
            { name: 'data', type: 'bytes', internalType: 'bytes' }
        ],
        outputs: [
            { name: '', type: 'bool', internalType: 'bool' },
            { name: '', type: 'bytes', internalType: 'bytes' }
        ],
        stateMutability: 'payable'
    },
    {
        type: 'function',
        name: 'getUserAccountData',
        inputs: [
            { name: '_userAddress', type: 'address', internalType: 'address' }
        ],
        outputs: [
            {
                name: 'totalCollateralBase',
                type: 'uint256',
                internalType: 'uint256'
            },
            {
                name: 'totalDebtBase',
                type: 'uint256',
                internalType: 'uint256'
            },
            {
                name: 'availableBorrowsBase',
                type: 'uint256',
                internalType: 'uint256'
            },
            {
                name: 'currentLiquidationThreshold',
                type: 'uint256',
                internalType: 'uint256'
            },
            { name: 'ltv', type: 'uint256', internalType: 'uint256' },
            { name: 'healthFactor', type: 'uint256', internalType: 'uint256' }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'name',
        inputs: [],
        outputs: [{ name: '', type: 'string', internalType: 'string' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'owner',
        inputs: [],
        outputs: [{ name: '', type: 'address', internalType: 'address' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'renounceOwnership',
        inputs: [],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'setProductivityGodAgent',
        inputs: [
            { name: '_agent', type: 'address', internalType: 'address' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'slashUser',
        inputs: [
            { name: '_user', type: 'address', internalType: 'address' },
            { name: '_amount', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'slashed',
        inputs: [{ name: '', type: 'address', internalType: 'address' }],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'symbol',
        inputs: [],
        outputs: [{ name: '', type: 'string', internalType: 'string' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'totalSupply',
        inputs: [],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'transfer',
        inputs: [
            { name: 'to', type: 'address', internalType: 'address' },
            { name: 'value', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [{ name: '', type: 'bool', internalType: 'bool' }],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'transferFrom',
        inputs: [
            { name: 'from', type: 'address', internalType: 'address' },
            { name: 'to', type: 'address', internalType: 'address' },
            { name: 'value', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [{ name: '', type: 'bool', internalType: 'bool' }],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'transferOwnership',
        inputs: [
            { name: 'newOwner', type: 'address', internalType: 'address' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'function',
        name: 'usdcToken',
        inputs: [],
        outputs: [
            { name: '', type: 'address', internalType: 'contract IERC20' }
        ],
        stateMutability: 'view'
    },
    {
        type: 'function',
        name: 'withdraw',
        inputs: [
            { name: '_amount', type: 'uint256', internalType: 'uint256' }
        ],
        outputs: [],
        stateMutability: 'nonpayable'
    },
    {
        type: 'event',
        name: 'Approval',
        inputs: [
            {
                name: 'owner',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: 'spender',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: 'value',
                type: 'uint256',
                indexed: false,
                internalType: 'uint256'
            }
        ],
        anonymous: false
    },
    {
        type: 'event',
        name: 'OwnershipTransferred',
        inputs: [
            {
                name: 'previousOwner',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: 'newOwner',
                type: 'address',
                indexed: true,
                internalType: 'address'
            }
        ],
        anonymous: false
    },
    {
        type: 'event',
        name: 'SlashUser',
        inputs: [
            {
                name: '_user',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: '_amount',
                type: 'uint256',
                indexed: false,
                internalType: 'uint256'
            }
        ],
        anonymous: false
    },
    {
        type: 'event',
        name: 'Transfer',
        inputs: [
            {
                name: 'from',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: 'to',
                type: 'address',
                indexed: true,
                internalType: 'address'
            },
            {
                name: 'value',
                type: 'uint256',
                indexed: false,
                internalType: 'uint256'
            }
        ],
        anonymous: false
    },
    {
        type: 'error',
        name: 'ERC20InsufficientAllowance',
        inputs: [
            { name: 'spender', type: 'address', internalType: 'address' },
            { name: 'allowance', type: 'uint256', internalType: 'uint256' },
            { name: 'needed', type: 'uint256', internalType: 'uint256' }
        ]
    },
    {
        type: 'error',
        name: 'ERC20InsufficientBalance',
        inputs: [
            { name: 'sender', type: 'address', internalType: 'address' },
            { name: 'balance', type: 'uint256', internalType: 'uint256' },
            { name: 'needed', type: 'uint256', internalType: 'uint256' }
        ]
    },
    {
        type: 'error',
        name: 'ERC20InvalidApprover',
        inputs: [
            { name: 'approver', type: 'address', internalType: 'address' }
        ]
    },
    {
        type: 'error',
        name: 'ERC20InvalidReceiver',
        inputs: [
            { name: 'receiver', type: 'address', internalType: 'address' }
        ]
    },
    {
        type: 'error',
        name: 'ERC20InvalidSender',
        inputs: [
            { name: 'sender', type: 'address', internalType: 'address' }
        ]
    },
    {
        type: 'error',
        name: 'ERC20InvalidSpender',
        inputs: [
            { name: 'spender', type: 'address', internalType: 'address' }
        ]
    },
    {
        type: 'error',
        name: 'OwnableInvalidOwner',
        inputs: [
            { name: 'owner', type: 'address', internalType: 'address' }
        ]
    },
    {
        type: 'error',
        name: 'OwnableUnauthorizedAccount',
        inputs: [
            { name: 'account', type: 'address', internalType: 'address' }
        ]
    }
] as const;

export const calls = [
    // {
    //     address: clickContractAddress,
    //     abi: clickContractAbi,
    //     functionName: 'click',
    //     args: [],
    //     // 
    // }
    {
        address: clickContractAddress,
        abi: clickContractAbi,
        functionName: 'deposit',
        inputs: [
            "_amount", "uint256", "uint256"
        ],
        // to: "0xA238Dd80C259a72e81d7e4664a9801593F98d1c5" as `0x${string}`,
    }
];