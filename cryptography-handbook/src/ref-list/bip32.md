# BIP32-ed25519

BIP32-ed25519 is an adaptation of the [BIP32](https://en.bitcoin.it/wiki/BIP_0032) proposal for
deterministic key generation for the Ed25519 curve which has non-linear key space.

## Implementation and bindings
We currently have two implementations of BIP32:
* C: Available in [cardano-crypto](https://github.com/input-output-hk/cardano-crypto/tree/develop/cbits)
* Rust: Implemented by Vincent Hanquez, [here](https://github.com/typed-io/rust-ed25519-bip32/).

The preferred implementation is that of Rust, but both are safe to use.

For the C implementation, we have bindings in the following languages:
* Haskell: Available in [cardano-crypto](https://github.com/input-output-hk/cardano-crypto/tree/develop/src/Crypto/ECC)

## Common mistakes
As the underlying signature algorithm is ed25519, we refer the reader to [common mistakes](./ed25519.md#common-mistakes)
of that section.