// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/src/Script.sol";
import {Vault} from "../src/Vault.sol";

// // Base
// address constant addressProvider = 0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D;
// address constant usdc = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
// address constant aUsdc = 0x4e65fE4DbA92790696d040ac24Aa414708F5c0AB;

// // Sepolia Base
// address constant addressProvider = 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A;
// address constant usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
// address constant aUsdc = 0x1E933bC6C4D1B2176D8Ac890a836040CDE8b79D0;

// Arbitrum
address constant addressProvider = 0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb;
address constant usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
address constant aUsdc = 0x625E7708f30cA75bfd92586e17077590C60eb4cD;

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        vault = new Vault(addressProvider, usdc, aUsdc);

        vm.stopBroadcast();
    }
}
