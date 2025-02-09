// SPDX-License-Identifier: MIT
pragma solidity <=0.8.28;

// Import AAVE interfaces
import {IPool} from "@aave/aave-v3-core/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IAToken} from "@aave/aave-v3-core/contracts/interfaces/IAToken.sol";
import {IERC20} from "@aave/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {ERC20} from "@aave/aave-v3-core/contracts/dependencies/openzeppelin/contracts/ERC20.sol";
import "forge-std/src/console.sol";

contract Vault is ERC20 {
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;
    address payable owner;

    IERC20 public immutable usdcToken =
        IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
    IERC20 public immutable aBasUsdc =
        IERC20(0x4e65fE4DbA92790696d040ac24Aa414708F5c0AB);

    mapping(address => uint256) public userRewards;

    constructor(address _addressProvider) ERC20("VaultUSDC", "vUSDC") {
        owner = payable(msg.sender);
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        _mint(msg.sender, _amount);
        usdcToken.transferFrom(msg.sender, address(this), _amount);
        _supplyLiquidity(_amount);
    }

    function _supplyLiquidity(uint256 _amount) internal {
        require(
            usdcToken.balanceOf(address(this)) >= _amount,
            "contract balance is less than amount"
        );

        address onBehalfOf = address(this);
        uint16 referralCode = 0;
        usdcToken.approve(address(POOL), _amount);
        console.log(usdcToken.balanceOf(address(this)));
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

    function checkDAOReward() external view returns (uint256) {
        return aBasUsdc.balanceOf(address(this));
    }

    function checkUserReward(
        address _user,
        uint256 _slashed
    ) external view returns (uint256) {
        return calculateUserReward(_user, _slashed);
    }

    function calculateUserReward(
        address _user,
        uint256 _slashed
    ) internal view returns (uint256) {
        if (totalSupply() == 0) {
            return 0;
        }
        require(_slashed <= 1e18, "invalid _slashed value");
        // Calculate the final reward after slashing
        return
            ((1e18 - _slashed) *
                (aBasUsdc.balanceOf(address(this)) - totalSupply()) *
                balanceOf(_user)) / (1e18 * totalSupply());
    }

    function claimDAOReward() external {
        withdrawlLiquidity(aBasUsdc.balanceOf(address(this)));
    }

    function claimUserRewards(address _user, uint256 _slashed) external {
        // here you take the msg.sender, you check its amount of protocol tokens, send the share of rewards minus what was slashed, send the slashed amount to the DAO
        // require(balanceOf(msg.sender)>=_amount,"withdrawing more than the available");
        uint256 calculatedRewards = calculateUserReward(_user, _slashed);
        withdrawlLiquidity(calculatedRewards);
        usdcToken.transfer(msg.sender, calculatedRewards);
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

    function approve(uint256 _amount) external returns (bool) {
        return usdcToken.approve(address(POOL), _amount);
    }

    function allowance() external view returns (uint256) {
        return usdcToken.allowance(address(this), address(POOL));
    }

    function getBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
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
