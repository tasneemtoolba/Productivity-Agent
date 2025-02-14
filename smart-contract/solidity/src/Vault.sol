// SPDX-License-Identifier: MIT
pragma solidity <=0.8.28;

// Import AAVE interfaces
import {IPool} from "@aave/aave-v3-core/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IAToken} from "@aave/aave-v3-core/contracts/interfaces/IAToken.sol";
import "forge-std/src/console.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// TODO use checkpoint math to make sure no one can "flash steal" the rewards
contract Vault is ERC20, Ownable {
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    IERC20 public immutable usdcToken;
    IERC20 public immutable aUsdcToken;

    uint256 totalClaimed;
    mapping(address => uint256) public claimedRewards; // user => claimed rewards
    mapping(address => uint256) public slashed; // user => slashed amount out of 1e18

    address productivityGodAgent;

    uint256 public daoRewards;

    event SlashUser(address indexed _user, uint256 _amount);
    event Deposit(address indexed _user, uint256 _amount);
    event Withdraw(address indexed _user, uint256 _amount);
    event ClaimUserRewards(address indexed _user, uint256 _userRewards);
    event ClaimRewardsDAO(uint256 _daoRewards);

    constructor(
        address _addressProvider,
        address _usdcToken,
        address _aUsdcToken
    ) ERC20("Productivity God USDC", "pgUSDC") Ownable(msg.sender) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
        IERC20(_usdcToken).approve(address(POOL), type(uint256).max);

        usdcToken = IERC20(_usdcToken);
        aUsdcToken = IERC20(_aUsdcToken);
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        usdcToken.transferFrom(msg.sender, address(this), _amount);
        _supplyLiquidity(_amount);
        _mint(msg.sender, _amount);
        emit Deposit(msg.sender, _amount);
    }

    function _supplyLiquidity(uint256 _amount) internal {
        require(
            usdcToken.balanceOf(address(this)) >= _amount,
            "contract balance is less than amount"
        );

        address onBehalfOf = address(this);
        uint16 referralCode = 0;
        usdcToken.approve(address(POOL), _amount);
        POOL.supply(address(usdcToken), _amount, onBehalfOf, referralCode);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            balanceOf(msg.sender) >= _amount,
            "user balance is less than amount"
        );
        // require(balanceOf(msg.sender)>=_amount,"withdrawing more than the available");
        withdrawlLiquidity(_amount);
        usdcToken.transfer(msg.sender, _amount);
        _burn(msg.sender, _amount);
        emit Withdraw(msg.sender, _amount);
    }

    function withdrawlLiquidity(uint256 _amount) internal returns (uint256) {
        address asset = address(usdcToken);
        uint256 amount = _amount;
        address to = address(this);

        return POOL.withdraw(asset, amount, to);
    }

    // Users can claim (1 - x) * p * a LP reward tokens
    // where a is the total available rewards in the contract,
    // p is the percentage of liquidity provided by the user
    // and x is the percentage of reward that was slashed by the users’ lack of productivity.
    // _slashed is out of 10e18 ether. So 10e18 would be 100%, 10e17 would be 10%, etc

    function calculateRewards(
        address _user
    ) public view returns (uint256 _userRewards, uint256 _daoRewards) {
        if (totalSupply() == 0) {
            _userRewards = 0;
            _daoRewards = 0;
        }

        uint256 baseReward = ((aUsdcToken.balanceOf(address(this)) -
            totalSupply() +
            totalClaimed) * balanceOf(_user)) /
            totalSupply() -
            claimedRewards[_user];

        // Calculate the final reward after slashing
        _userRewards = ((1e18 - slashed[_user]) * baseReward) / 1e18;
        _daoRewards = (slashed[_user] * baseReward) / 1e18;
    }

    function setProductivityGodAgent(address _agent) external onlyOwner {
        productivityGodAgent = _agent;
    }

    function slashUser(address _user, uint256 _amount) external {
        require(msg.sender == productivityGodAgent, "Not agent");
        slashed[_user] = slashed[_user] + _amount > 1 ether
            ? slashed[_user] + _amount
            : 1 ether;

        emit SlashUser(_user, slashed[_user]);
    }

    function claimDAOReward() external {
        withdrawlLiquidity(daoRewards);
        emit ClaimRewardsDAO(daoRewards);
        daoRewards = 0;
    }

    function claimUserRewards(address _user) external {
        // here you take the msg.sender, you check its amount of protocol tokens, send the share of rewards minus what was slashed, send the slashed amount to the DAO
        // require(balanceOf(msg.sender)>=_amount,"withdrawing more than the available");
        (uint256 _userRewards, uint256 _daoRewards) = calculateRewards(_user);

        totalClaimed += _userRewards + _daoRewards;
        claimedRewards[_user] += _userRewards;
        daoRewards += _daoRewards;
        slashed[_user] = 0;

        withdrawlLiquidity(_userRewards);
        usdcToken.transfer(_user, _userRewards);
        emit ClaimUserRewards(_user, _userRewards);
    }

    function getUserAccountData(
        address _userAddress
    )
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

    receive() external payable {}

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable onlyOwner returns (bool, bytes memory) {
        (bool success, bytes memory result) = to.call{value: value}(data);
        return (success, result);
    }
}
