# Schnorr

Schnorr is one of signature schemes supported natively in Plutus, together with [ed25519](./ed25519.md) and [ECDSA](./ecdsa.md). In
particular, the natively supported ECDSA algorithm works over curve SECP256k1, enabling support for Bitcoin's and Ethereum's native
signatures. Schnorr signature scheme is also adopted by [MuSig2](https://eprint.iacr.org/2020/1261) (Simple 
Two-Round Schnorr Multisignatures) which will be integrated to Hydra.

## Implementation and binding
We currently relly in Bitcoin's implementation available in [secp256k1](https://github.com/bitcoin-core/secp256k1/tree/master/src/modules/schnorrsig).
We have analysed, and recommend, bindings in the following languages:

* Haskell: Available in [cardano-base](https://github.com/input-output-hk/cardano-base/blob/master/cardano-crypto-class/src/Cardano/Crypto/DSIGN/SchnorrSecp256k1.hs)

### MuSig2
This API also relies on [secp256k1](https://github.com/bitcoin-core/secp256k1/tree/master/src/modules/schnorrsig) 
that is compatible with [BIP-340](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki) producing
64-byte Schnorr signatures.

* C: Available in [musig2](https://github.com/input-output-hk/musig2/tree/main). Note that this API is still in 
  progress. 