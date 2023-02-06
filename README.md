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
---------------------------------------------------------
| DEPLOYED : 0x958AC676883B6ccc46609dd6511932c03871BA49 |
---------------------------------------------------------

ETH_ADDRESS_TESTNET = 0x0000000000000000000000000000000000000000; // 1
WBTC_ADDRESS_TESTNET = 0xC04B0d3107736C32e19F1c62b2aF67BE61d63a05; // 2
LINK_ADDRESS_TESTNET = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB; // 3
USDT_ADDRESS_TESTNET = 0xC2C527C0CACF457746Bd31B2a698Fe89de2b6d49; // 4
DAI_ADDRESS_TESTNET = 0xdc31Ee1784292379Fbb2964b3B9C4124D8F89C60; // 5

// * Address of price feeds
ETH_PRICE = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e; // 1
WBTC_PRICE = 0xA39434A63A52E749F02807ae27335515BA4b07F7; // 2
LINK_PRICE = 0x48731cF7e84dc94C5f84577882c14Be11a5B7456; // 3
```
