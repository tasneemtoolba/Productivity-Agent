// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        //_addressesProvider testnet = 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A
        //_addressesProvider mainnet = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e
        vault = new Vault();

        vm.stopBroadcast();
    }
}
