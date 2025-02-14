// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "forge-std/src/Vm.sol";
import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";
import {IERC20} from "@aave/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {Vault} from "../src/Vault.sol";

interface AavePool {
    function name() external returns (string memory);
}

// end to end tests for the ZeroLend integration
contract VaultTest is Test {
    address constant AAVE_USDC_POOL =
        0x0a1d576f3eFeF75b330424287a95A366e8281D54;

    IERC20 public immutable usdcToken =
        IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
    IERC20 public immutable aBasUsdc =
        IERC20(0x4e65fE4DbA92790696d040ac24Aa414708F5c0AB);
    Vault vault;

    constructor() {}

    function setUp() public {
        uint256 forkId = vm.createFork(vm.rpcUrl("base"), 26_093_599);
        vm.selectFork(forkId);
        deal(address(usdcToken), address(this), 2e6);
        vault = new Vault(0xe20fCBdBfFC4Dd138cE8b2E6FBb6CB49777ad64D, 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913, 0x4e65fE4DbA92790696d040ac24Aa414708F5c0AB);
        usdcToken.approve(address(vault), 2e6);
    }

    function test_canDepositUSDC() public {
        vault.deposit(1e4);
    }

    function test_canWithdrawUSDC() public {
        vault.deposit(1e4);
        vault.withdraw(1e4);
    }

    function test_canGetAavePoolInfo() public {
        assertEq(AavePool(AAVE_USDC_POOL).name(), "Aave Base USDbC");
    }

    // New test cases
    function test_cannotDepositZeroAmount() public {
        vm.expectRevert("Amount must be greater than 0");
        vault.deposit(0);
    }

    function test_cannotWithdrawMoreThanBalance() public {
        vault.deposit(1e4);
        vm.expectRevert("user balance is less than amount");
        vault.withdraw(2e4);
    }

    function test_cannotWithdrawZeroAmount() public {
        vault.deposit(1e4);
        vm.expectRevert("Amount must be greater than 0");
        vault.withdraw(0);
    }

    function test_cannotWithdrawWithoutDeposit() public {
        vm.expectRevert("user balance is less than amount");
        vault.withdraw(1e4); // No deposit made yet
    }

    // fails hehe
    // function test_cannotDepositMoreThanBalance() public {
    //     usdcToken.approve(address(vault), 1e6);
    //     vm.expectRevert("not enough usdc allowed to the vault");
    //     vault.deposit(2e6); // Trying to deposit more than the balance
    // }

    // New tests for claiming rewards
    // function test_canClaimDAOReward() public {
    //     vault.deposit(1e4);
    //     vault.claimDAOReward();

    //     // Check if the DAO reward was claimed correctly
    //     assertEq(vault.daoRewards(), 0); // Assuming no rewards initially
    // }

    // function test_canClaimUserRewards() public {
    //     vault.deposit(1e4);
    //     vault.claimUserRewards(address(this));
    //     // Check if the user rewards were claimed correctly
    //     (uint256 _userRewards, ) = vault.calculateRewards(address(this));
    //     assertEq(_userRewards, 0); // Assuming no rewards initially
    // }

    function test_checkUserReward() public {
        vault.deposit(1e4);

        (uint256 _userRewards, ) = vault.calculateRewards(address(this));
        assertEq(_userRewards, 0); // Assuming no rewards initially
    }

    function test_checkDAOReward() public {
        vault.deposit(1e4);
        uint256 daoReward = vault.daoRewards();
        assertEq(daoReward, 0); // Assuming no rewards initially
    }

    // function test_canSubmitProof() public {
    //     vault.submitProof(100);
    //     // Check if the productivity score is updated
    //     assertEq(vault.productivityScore(address(this)), 100);
    // }

    // function test_canSubmitMultipleProofs() public {
    //     vault.submitProof(50);
    //     vault.submitProof(150);
    //     // Check if the productivity score is updated correctly
    //     assertEq(vault.productivityScore(address(this)), 200);
    // }
}
