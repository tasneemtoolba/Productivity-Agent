import { TransactionReact } from "@coinbase/onchainkit/transaction";

const productivityGodContractAddress =
  "0x58944BCE9ccbd9C512c61CAab35fD4C892793bB1";
const usdcAddress = "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913";

const productivityGodContractAbi = [
  {
    type: "function",
    name: "deposit",
    inputs: [{ name: "_amount", type: "uint256", internalType: "uint256" }],
    outputs: [],
    stateMutability: "nonpayable",
  },
] as const;

const erc20Abi = [
  {
    constant: false,
    inputs: [
      {
        name: "_spender",
        type: "address",
      },
      {
        name: "_value",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export const calls: TransactionReact["calls"] = [
  {
    address: usdcAddress,
    abi: erc20Abi,
    functionName: "approve",
    args: [productivityGodContractAddress, 10000],
  },
  {
    address: productivityGodContractAddress,
    abi: productivityGodContractAbi,
    functionName: "deposit",
    args: [10000],
  },
];
