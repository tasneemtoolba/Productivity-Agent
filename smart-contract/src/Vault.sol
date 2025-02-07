// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.28;

// Import AAVE interfaces
import { IPool } from "@aave/aave-v3-core/contracts/interfaces/IPool.sol";
import { IPoolAddressesProvider } from "@aave/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import { IAToken } from "@aave/aave-v3-core/contracts/interfaces/IAToken.sol";
// import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;
    address payable owner;

    IERC20 public immutable token;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) public userRewards;
    mapping(address => uint256) public productivityScore;
    uint256 public totalRewards;

    constructor(address _token, address _addressProvider) {
        token = IERC20(_token);
        owner = payable(msg.sender);
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
    }

    function _mint(address _to, uint256 _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint256 _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint256 _amount) external {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint256 shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        // token.transferFrom(msg.sender, address(this), _amount);
        require(_amount > 0, "Amount must be greater than 0");
        require(token.balanceOf(msg.sender) >= _amount, "user balance should be more than amount");
        supplyLiquidity(_amount);
    }

    function withdraw(uint256 _shares) external {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T
        */
        uint256 _amount = (_shares * token.balanceOf(address(this))) /
            totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, _amount);
        withdrawlLiquidity(_amount);
    }


    function approveTokens(address _spender, uint256 _amount) external {
        token.approve(_spender, _amount);
    }

    function submitProof(uint256 _score) external {
        productivityScore[msg.sender] = _score;
    }

    // function harvestRewards() external {
    //     totalRewards += ;
    // }

    // function claimRewards() external {
    //     uint256 userReward = userRewards[msg.sender];
    //     require(userReward > 0, "No rewards to claim");
    //     userRewards[msg.sender] = 0;
    //     token.transfer(msg.sender, userReward);
    // }

    // function claimDAOSlashedRewards() external {
        // Logic for DAO to claim rewards based on slashed tokens
    // }
  function supplyLiquidity(uint256 _amount) internal {
        uint256 amount = _amount;
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        POOL.supply(address(token), amount, onBehalfOf, referralCode);
    }

    function withdrawlLiquidity(uint256 _amount)
        internal
        returns (uint256)
    {
        address asset = address(token);
        uint256 amount = _amount;
        address to = address(this);

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
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner, address indexed spender, uint256 amount
    );
}