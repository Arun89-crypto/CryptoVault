// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CryptoVault {
    struct Vault {
        address creator;
        string name;
        address[] users;
        uint256 amount;
    }

    uint256 totalVaults;
    mapping(uint256 => Vault) public vaults;
    mapping(address => uint256) public balance;

    // EVENTS
    event VaultDistribution(uint256 vaultId, uint256 amount);

    constructor() {}

    /*
    memory : when we don't have to modify the stuff
    storage : when we need to modify the stuff 
    */

    function createVault(
        string memory _name,
        address[] memory _users,
        uint256 _initialAmount
    ) public returns (uint256 vaultId) {
        Vault storage vault = vaults[totalVaults];
        vault.creator = msg.sender;
        vault.name = _name;
        vault.users = _users;
        vault.amount = _initialAmount;
        totalVaults++;
        return totalVaults - 1;
    }

    function addAmount(uint256 _vaultId, uint256 _amount) public {
        Vault storage vault = vaults[_vaultId];
        require(
            msg.sender == vault.creator,
            "You need to be vault creator in order to add amount"
        );
        vault.amount += _amount;
    }

    function distribute(uint256 _vaultId) public {
        Vault storage vault = vaults[_vaultId];
        require(
            msg.sender == vault.creator,
            "You need to be vault creator in order to add amount"
        );
        uint256 amountPerUser = vault.amount / vault.users.length;
        if (vault.amount != 0) {
            for (uint256 i; i < vault.users.length; i++) {
                vault.amount -= amountPerUser;
                balance[vault.users[i]] = amountPerUser;
            }
        } else {
            revert("No funds Available");
        }
        emit VaultDistribution(_vaultId, amountPerUser * vault.users.length);
    }
}
