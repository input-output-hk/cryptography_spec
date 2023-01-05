# KES

In Cardano, nodes use Key Evolving Signatures (KES).
This is another asymmetric key cryptographic scheme, also relying on
the use of public and private key pairs.
These signature schemes provide forward cryptographic security, meaning that a
compromised key does not make it easier for an adversary to forge a signature that
allegedly had been signed in the past.

In KES, the public verification key stays constant, but the
corresponding private key evolves incrementally. For this reason, KES
signing keys are indexed by integers representing the step in the key's
evolution. Since the private key evolves incrementally in a KES scheme, the ledger rules
require the pool operators to evolve their keys every time a certain number of
slots have passed. The details of when these keys are evolved are out of the
scope of this document, and the reader is directed to the 
[ledger spec](https://github.com/input-output-hk/cardano-ledger#repository-structure).


## Implementation and bindings
The Cardano compatible KES implementations are
* Haskell: Available in [cardano-base](https://github.com/input-output-hk/cardano-base/blob/master/cardano-crypto-class/src/Cardano/Crypto/KES/Class.hs)
* Rust: Available in [crates.io](https://crates.io/crates/kes-summed-ed25519)

The particular instantiation used in Cardano is of depth 6. An improvement on the representation of signatures
is being worked on, and planned to be included in the next HF. This compact representation is available in 
both the Haskell 
[library](https://github.com/input-output-hk/cardano-base/blob/master/cardano-crypto-class/src/Cardano/Crypto/KES/CompactSum.hs)
and the [rust counterpart](https://docs.rs/kes-summed-ed25519/0.1.1/kes_summed_ed25519/kes/struct.Sum6CompactKesSig.html).

**Note**: The secret key representations of both libraries _are not_ compatible. A padding strategy can be made to
use Haskell generated data in Rust, but not vice-versa. To see this padding trick, you can look in the interoperability
tests of the [rust library](https://github.com/input-output-hk/kes/blob/2242497efa7a421fcc82e2a3ff509bb43d00eb3e/tests/interoperability.rs#L45).

## Common mistakes
The main building block of KES is its underlying signature scheme, Ed25519. We refer the reader to the common mistakes
[section](ed25519.md#common-mistakes) of Ed25519.
