# ECDSA

ECDSA is one of signature schemes supported natively in Plutus, together with [ed25519](./ed25519.md) and [Schnorr](./schnorr.md). In 
particular, the natively supported ECDSA algorithm works over curve SECP256k1, enabling support for Bitcoin's and Ethereum's native
signatures.

## Implementation and bindings
We currently relly in Bitcoin's implementation available in [secp256k1](https://github.com/bitcoin-core/secp256k1/blob/master/src/secp256k1.c#L444). 
We have analysed, and recommend, bindings in the following languages:

* Haskell: Available in [cardano-base](https://github.com/input-output-hk/cardano-base/blob/master/cardano-crypto-class/src/Cardano/Crypto/DSIGN/EcdsaSecp256k1.hs)

## Common mistakes
An ECDSA signature consists of two values $ (r,s) $, where are scalars. A problem of using ECDSA in consensus critical
contexts, is that the signature algorithm (as defined in the standard) is [malleable](https://bitcoin.stackexchange.com/questions/83408/in-ecdsa-why-is-r-%E2%88%92s-mod-n-complementary-to-r-).
Specifically, given a valid signature $(r, s)$, the tuple $(r, -s)$ is also a valid signature.
To avoid problems resulting from this malleability, the implementation we use [checks that](https://github.com/bitcoin-core/secp256k1/blob/master/src/secp256k1.c#L455) the $$ s < p/2$$, where $p$ is
the order of the prime order group. More details of such a check in the [spec](./../specs/ecdsa.md) section. 
