// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.28;

// Import AAVE interfaces
import { IPool } from "@aave/aave-v3-core/contracts/interfaces/IPool.sol";
import { IPoolAddressesProvider } from "@aave/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import { IAToken } from "@aave/aave-v3-core/contracts/interfaces/IAToken.sol";
import {IERC20} from "@aave/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Vault {
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;
    address payable owner;

    IERC20 public immutable token;

    mapping(address => uint256) public userRewards;
    mapping(address => uint256) public productivityScore;
    uint256 public totalRewards;

    constructor(address _token, address _addressProvider) {
        token = IERC20(_token);
        owner = payable(msg.sender);
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
    }


    function approveTokens(address _spender, uint256 _amount) external {
        token.approve(_spender, _amount);
    }

    function submitProof(uint256 _score) external {
        productivityScore[msg.sender] = _score;
    }
    
    // function claimRewards() external {
    //     uint256 userReward = userRewards[msg.sender];
    //     require(userReward > 0, "No rewards to claim");
    //     userRewards[msg.sender] = 0;
    //     token.transfer(msg.sender, userReward);
    // }

    // function claimDAOSlashedRewards() external {
        // Logic for DAO to claim rewards based on slashed tokens
    // }
  function deposit(uint256 _amount, address _poolContractAddress) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(token.balanceOf(msg.sender) >= _amount, "user balance should be more than amount");
        
        address onBehalfOf = msg.sender;
        uint16 referralCode = 0;
        token.approve(_poolContractAddress, _amount);
        POOL.supply(address(token), _amount, onBehalfOf, referralCode);
    }

    function withdraw(uint256 _amount)
        internal
        returns (uint256)
    {
        address asset = address(token);
        uint256 amount = _amount;
        address to = msg.sender;

        return POOL.withdraw(asset, amount, to);
    }

    function getUserAccountData(address _userAddress)
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        return POOL.getUserAccountData(_userAddress);
    }

    function approveLINK(uint256 _amount, address _poolContractAddress)
        external
        returns (bool)
    {
        return token.approve(_poolContractAddress, _amount);
    }

    function allowanceLINK(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return token.allowance(address(this), _poolContractAddress);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }


    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
  
}