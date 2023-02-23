# Mithril

Mithril is a stake-based threshold signature scheme that is currently being developed by the core team. It's goal
is to provide certificates that are valid under the same assumptions as Cardano main-net, namely that the majority
of Cardano's stake is honest. 


## Implementation and bindings
The implementation of the core library is in rust. However, the code has not yet been audited (for more information
on when the code will be audited, please contact the mithril team in [discord](https://discord.gg/5kaErDKDRq). The 
crate can be found in crates.io:

* mithril-stm: https://crates.io/crates/mithril-stm

The library above only exposes the cryptographic primitives that 
are used in the protocol. Other libraries of interest (which we will not cover in detail in the handbook) are the 
following:

* mithril-signer: https://github.com/input-output-hk/mithril/tree/main/mithril-signer
* mithril-client: https://github.com/input-output-hk/mithril/tree/main/mithril-client
* mithril-aggregator: https://github.com/input-output-hk/mithril/tree/main/mithril-aggregator

## Security
This library has not been audited.
