// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Imports
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CryptoVault is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // * Address of tokens
    address public ETH_ADDRESS_TESTNET =
        0x7c1ed097af300c85f3e9aaf51a15de5c967f828e; // 1
    address public WBTC_ADDRESS_TESTNET =
        0xc04b0d3107736c32e19f1c62b2af67be61d63a05; // 2
    address public LINK_ADDRESS_TESTNET =
        0x326c977e6efc84e512bb9c30f76e30c160ed06fb; // 3
    address public USDT_ADDRESS_TESTNET =
        0xe802376580c10fe23f027e1e19ed9d54d4c9311e; // 4
    address public DAI_ADDRESS_TESTNET =
        0xdc31ee1784292379fbb2964b3b9c4124d8f89c60; // 5

    // * Address of price feeds
    address public ETH_PRICE = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e; // 101
    address public WBTC_PRICE = 0xA39434A63A52E749F02807ae27335515BA4b07F7; // 102
    address public LINK_PRICE = 0x48731cF7e84dc94C5f84577882c14Be11a5B7456; // 102

    // * Items struct
    struct Items {
        IERC20 token; // 1 | 2 | 3
        address withdrawer;
        uint256 amount;
        uint256 depositedTokenType; // 1 | 2 | 3
        uint256 unlockTimeStamp;
        bool withdraw;
        bool deposited;
        uint256 tokensLoaned;
        uint256 tokenTypeLoaned; // 4 | 5
    }

    // * Vars & Mappings
    uint256 public depositsCount;

    mapping(address => uint256[]) public depositsByTokenAddress;
    mapping(address => uint256[]) public depositsByWithdrawers;
    mapping(uint256 => Items) public lockedToken;
    mapping(address => mapping(address => uint256)) public walletTokenBalance;
    mapping(uint256 => address) public tokenAddresses;
    mapping(uint256 => address) public tokenPriceFeedAddresses;

    address public contractOwnerAddress;
    AggregatorV3Interface internal priceFeed;

    constructor() {
        contractOwnerAddress = msg.sender;

        tokenAddresses[1] = ETH_ADDRESS_TESTNET;
        tokenAddresses[2] = WBTC_ADDRESS_TESTNET;
        tokenAddresses[3] = LINK_ADDRESS_TESTNET;
        tokenAddresses[4] = USDT_ADDRESS_TESTNET;
        tokenAddresses[5] = DAI_ADDRESS_TESTNET;

        tokenPriceFeedAddresses[1] = ETH_PRICE;
        tokenPriceFeedAddresses[2] = WBTC_PRICE;
        tokenPriceFeedAddresses[3] = LINK_PRICE;
    }

    // * EVENTS
    event tokensLocked(
        IERC20 _token,
        address _withdrawer,
        uint256 _amount,
        IERC20 _outputToken,
        uint256 _unlockTimestamp
    );
    event tokensWithdrawn(address _withdrawer, uint256 _amount);

    /// @dev This is a function to lock the tokens in a vault and recieve a loan amount
    /// @param _token Address of the token deposited
    /// @param _withdrawer Address of the wallet who will be able to withdraw the amount
    /// @param _amount Amount of token deposited
    /// @param _outputToken Token type got as an output
    /// @param _unlockTimestamp Timestamp at which vault will be available for withdraw
    function lockTokens(
        IERC20 _token,
        address _withdrawer,
        uint256 _amount,
        uint256 _depositedTokenType,
        IERC20 _outputToken,
        uint256 _outputTokenType,
        uint256 _unlockTimestamp
    ) public payable returns (uint256 _id) {
        // Checks
        require(
            _unlockTimestamp < 10000000000,
            "Unlock timestamp is not in seconds!"
        );
        require(
            _unlockTimestamp > block.timestamp,
            "Unlock timestamp is not in the future!"
        );
        require(
            _token.allowance(msg.sender, address(this)) >= _amount,
            "Approve tokens first!"
        );
        require(msg.value >= _amount, "Unsufficient Balance!");

        // Transfering tokens from user to contract
        _token.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 price = _getTokenPrice(_outputToken, _amount);
        _outputToken.transfer(msg.sender, price);
        // adding the token balance in the wallet of particular address
        walletTokenBalance[address(_token)][msg.sender] = walletTokenBalance[
            address(_token)
        ][msg.sender].add(_amount);

        _id = ++depositsCount;
        lockedToken[_id].token = _token;
        lockedToken[_id].withdrawer = _withdrawer;
        lockedToken[_id].amount = _amount;
        lockedToken[_id].depositedTokenType = _depositedTokenType;
        lockedToken[_id].unlockTimestamp = _unlockTimestamp;
        lockedToken[_id].withdrawn = false;
        lockedToken[_id].deposited = true;
        lockedToken[_id].tokensLoaned = price;
        lockedToken[_id].tokenTypeLoaned = _outputTokenType;

        BalanceOfVault[_depositedTokenType] += _amount;

        depositsByTokenAddress[address(_token)].push(_id);
        depositsByWithdrawers[_withdrawer].push(_id);
        return _id;
    }

    /// @dev Function to get the latest price of the token in USD
    /// @param _tokenAddress address of the token
    /// @param _amount amount of the tokens deposited
    function _getTokenPrice(uint256 _tokenType, uint256 _amount)
        private
        returns (uint256)
    {
        address aggregatorAddress;
        priceFeed = AggregatorV3Interface(tokenPriceFeedAddresses[_tokenType]);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        uint256 _price = uint256(answer * 10000000000);
        return (_price * _amount) / 1000000000000000000;
    }

    /// @dev Function to withdraw the vault tokens
    /// @param _id ID of the vault
    function withdrawTokens(uint256 _id) external {
        require(
            block.timestamp >= lockedToken[_id].unlockTimestamp,
            "Tokens are still locked!"
        );
        require(
            msg.sender == lockedToken[_id].withdrawer,
            "You are not the withdrawer!"
        );
        require(lockedToken[_id].deposited, "Tokens are not yet deposited!");
        require(!lockedToken[_id].withdrawn, "Tokens are already withdrawn!");
        require(
            lockedToken[_id].withdrawer == msg.sender,
            "You are not allowed to with draw to the tokens!"
        );
        require(
            IERC20(tokenAddresses[lockedToken[_id].tokenTypeLoaned]) >=
                lockedToken[_id].amount,
            "You don't have enough balances to unlock your vault!"
        );

        lockedToken[_id].withdrawn = true;

        walletTokenBalance[address(lockedToken[_id].token)][
            msg.sender
        ] = walletTokenBalance[address(lockedToken[_id].token)][msg.sender].sub(
            lockedToken[_id].amount
        );

        // * Transfering funds from User => System

        IERC20(tokenAddresses[lockedToken[_id].tokenTypeLoaned]).transfer(
            address(this),
            lockedToken[_id].amount
        );

        // * Transfering funds from System => User

        IERC20(tokenAddresses[lockedToken[_id].depositedTokenType])
            .safeTransferFrom(
                msg.sender,
                address(this),
                lockedToken[_id].amount
            );

        emit Withdraw(msg.sender, lockedToken[_id].amount);
    }

    function getDepositsByTokenAddress(address _id)
        external
        view
        returns (uint256[] memory)
    {
        return depositsByTokenAddress[_id];
    }

    function getDepositsByWithdrawer(address _token, address _withdrawer)
        external
        view
        returns (uint256)
    {
        return walletTokenBalance[_token][_withdrawer];
    }

    function getVaultsByWithdrawer(address _withdrawer)
        external
        view
        returns (uint256[] memory)
    {
        return depositsByWithdrawers[_withdrawer];
    }

    function getVaultById(uint256 _id) external view returns (Items memory) {
        return lockedToken[_id];
    }

    function getTokenTotalLockedBalance(address _token)
        external
        view
        returns (uint256)
    {
        return IERC20(_token).balanceOf(address(this));
    }
}
