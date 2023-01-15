# CryptoVault 🔐

CryptoVault is a vault on blockchain in which we can deposit our funds and then we can withdraw them in exchange of the stable coins which we got in exchange of the amount we staked in the vault.

**How crypto vaults works ?**

```

Time T1 (initial time) :
----------------------

User : 500 XYZ (2 STABLECOIN = 1 XYZ)

          $CRYPTO$
[USER] -------------> [Vault]
       <-------------
          $STABLECOIN$

User : 1000 STABLECOIN (Asset returned by vault in exchange of the deposits as stable crypto)

Time T2 (after sometime) :
------------------------

User : 1000 STABLECOIN (Asset submitted to vault to get the deposited assets back which have higher value now)

          $STABLECOIN$
[USER] ------------> [Vault]
       <------------
          $CRYPTO$

User : 500 XYZ (2.75 STABLECOIN = 1 XYZ)

Value before lock : 1000 $STABLECOIN$
Value after lock : 1375 $STABLECOIN$

Profit % : (375 / 1000) * 100 = 37.5 %

CONCLUSION
----------

Here user had a profit and now owns much more worth of crypto that he/she/they owned it at time T1.

```

## Currencies Supported

The Vault supports ETH network and soon will support Cross chain.

```txt
ETH_ADDRESS_TESTNET = 0x7c1ed097af300c85f3e9aaf51a15de5c967f828e; // 1
WBTC_ADDRESS_TESTNET = 0xc04b0d3107736c32e19f1c62b2af67be61d63a05; // 2
LINK_ADDRESS_TESTNET = 0x326c977e6efc84e512bb9c30f76e30c160ed06fb; // 3
USDT_ADDRESS_TESTNET = 0xe802376580c10fe23f027e1e19ed9d54d4c9311e; // 4
DAI_ADDRESS_TESTNET = 0xdc31ee1784292379fbb2964b3b9c4124d8f89c60; // 5

// * Address of price feeds
ETH_PRICE = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e; // 1
WBTC_PRICE = 0xA39434A63A52E749F02807ae27335515BA4b07F7; // 2
LINK_PRICE = 0x48731cF7e84dc94C5f84577882c14Be11a5B7456; // 3
```
