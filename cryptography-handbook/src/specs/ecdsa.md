# ECDSA

ECDSA, together with Schnorr, were two new signature algorithms introduced in Plutus during Cardano's Valentine upgrade.

## Generalised specification
This section presents the generalized signature system ECDSA, and in the [parameter](#parameters-of-instantiation) section, we present the
specific parameters used in Cardano. ECDSA is parametrized with the following parameters. An ECDSA signature 
consists of the following three algorithms:
* $ \keygen(1^\secparam) $ takes as input the security parameter $ \secparam $ and returns a key-pair $
  (\secretkey, \vk)$. First, it chooses $ \secretkey\gets Z_{\order} $. Finally, compute 
$ \vk \gets \secretkey \cdot \generator $, and return $ (\secretkey, \vk) $.
* $ \sign(\secretkey, \vk, m) $ takes as input a keypair $ (\secretkey, \vk) $ and a message $ m $, and returns a
  signature $ \signature $. Let $ k \gets Z_{\order} $. Compute $K = k \cdot * generator$ and interpret the
result as its two individual coordinates $(K_x, K_y)$. Next, compute $r \gets K_x \mod \order$. If $r=0$, 
generate a new $k$ and start over. Finally compute $s = k^{-1} (z + r * \secretkey) \mod \order$. If 
$s=0$, generate a new $k$ and start over. Otherwise, return $\signature = (r, s)$.
* $ \verify(m, \vk, \signature) $ takes as input a message $ m $, a verification key $ \vk $ and a signature
  $ \signature $, and returns $ r\in\{\accept, \reject\} $ depending on whether the signature is valid or not. The algorithm
  returns $ \accept $ if the following conditions hold and $ \reject $ otherwise:
    * $r$ and $s$ are between $1$ and $\order-1$.
    * Compute $u_1 = z \cdot s^{-1} \mod \order$ and $u_2 = r \cdot s^{-1} \mod \order$. Compute
      $(x, y) = u_1 \cdot \generator + u_2 \cdot \generator$, and ensure it is not equal to the point
      at infinity. Checks that $r = x \mod \order$.


## Parameters of instantiation
The above is the standard definition, and in cardano we instantiate it over curve SECP256k1. 
However, such a signature algorithm enables malleability. Given a valid signature $(r,s)$, if
one sets $s' = \order - s$, then the pair $(r, s')$ is also a valid signature, as a point $P$
and its negative $P'$ share the same x-coordinate. This can be problematic in consensus critical 
contexts. To that end, [we](https://github.com/input-output-hk/cardano-base/blob/master/cardano-crypto-class/src/Cardano/Crypto/SECP256K1/C.hs#L149)
follow [Bitcoin's modification](https://github.com/bitcoin-core/secp256k1/blob/master/src/secp256k1.c#L455) 
of only accepting signatures with small values of $s$, i.e. with $s < p / 2$.

The signatures generated using Haskell's bindings (see [here](../ref-list/ecdsa.md)) use hash
function SHA256. However, Plutus built-in function takes as input the hashed message, meaning 
that the signer and verifier can agree which hash function to use in their protocol. 

While we follow the verification criteria used in Bitcoin, we do not follow their serialisation 
convention, DER-encoding, which results in variable sized signatures up to 72 bytes (instead 
of the 64 byte encoding we describe in this document).

* The verification key must correspond to the _(x, y)_ coordinates of a point
  on the SECP256k1 curve, where _x, y_ are unsigned integers in big-endian form.
* The verification key must correspond to a result produced by
  [``secp256k1_ec_pubkey_serialize``](https://github.com/bitcoin-core/secp256k1/blob/master/include/secp256k1.h#L394),
  when given a length argument of 33, and the ``SECP256K1_EC_COMPRESSED`` flag.
  This implies all of the following:
  * The verification key is 33 bytes long.
  * The first byte corresponds to the parity of the _y_ coordinate; this is
    `0x02` if _y_ is even, and `0x03` otherwise.
  * The remaining 32 bytes are the bytes of the _x_ coordinate.
* The input to verify must be a 32-byte hash of the message to be checked. We
  assume that the caller of `verifyEcdsaSecp256k1Signature` receives the
  message and hashes it, rather than accepting a hash directly: doing so
  [can be dangerous](https://bitcoin.stackexchange.com/a/81116/35586).
  Typically, the hashing function used would be SHA256; however, this is not
  required, as only the length is checked.
* The signature must correspond to two unsigned integers in big-endian form;
  henceforth _r_ and _s_.
* The signature must correspond to a result produced by
  [``secp256k1_ecdsa_serialize_compact``](https://github.com/bitcoin-core/secp256k1/blob/master/include/secp256k1.h#L487).
  This implies all of the following:
  * The signature is 64 bytes long.
  * The first 32 bytes are the bytes of _r_.
  * The last 32 bytes are the bytes of _s_.
  ``` 
      ┏━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━┓
      ┃ r <32 bytes> │ s <32 bytes>  ┃
      ┗━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━┛
      <--------- signature ---------->
  ```
  