// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/src/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        //_addressesProvider testnet = 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A
        //_addressesProvider mainnet on base = 0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D 
        // usdc testnet = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238
        // usdc mainnet = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
        // a
        vault = new Vault(0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D);

        vm.stopBroadcast();
    }
}
