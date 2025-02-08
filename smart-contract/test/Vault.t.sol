// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "forge-std/src/Vm.sol";
import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";

interface AavePool {
    function name() external returns (string memory);
}

// end to end tests for the ZeroLend integration
contract VaultTest is Test {
    address constant AAVE_USDC_POOL = 0x0a1d576f3eFeF75b330424287a95A366e8281D54;

    constructor() {}

    function setUp() public {
        uint256 forkId = vm.createFork(vm.rpcUrl("base"), 26_093_599);
        vm.selectFork(forkId);
    }

    function test_canGetAavePoolInfo() public {
        assertEq(AavePool(AAVE_USDC_POOL).name(), "Aave Base USDbC");
    }
}
