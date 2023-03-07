# Schnorr

Schnorr, together with ECDSA, were two new signature algorithms introduced
in Plutus during Cardano's Valentine upgrade.

## Generalised specification
This section presents the generalized signature system ECDSA, and in the [parameter](#parameters-of-instantiation) section, we present the
specific parameters used in Cardano. A Schnorr signature consists of the following three algorithms:
* $ \keygen(1^\secparam) $ takes as input the security parameter $ \secparam $ and returns a key-pair $
  (\secretkey, \vk)$. First, it chooses $ \secretkey\gets Z_{\order} $. Finally, compute
  $ \vk \gets \secretkey \cdot \generator $, and return $ (\secretkey, \vk) $.
* $ \sign(\secretkey, \vk, m) $ takes as input a keypair $ (\secretkey, \vk) $ and a message $ m $, and returns a
  signature $ \signature $. Let $ k \gets Z_{\order} $. Compute $K = k \cdot * generator$, then compute
  $ c \gets \hash(K, pk, m)$, and finally compute $s = r + c \cdot \secretkey$. Let $\signature\gets (K, s)$.
* $ \verify(m, \vk, \signature) $ takes as input a message $ m $, a verification key $ \vk $ and a signature
  $ \signature $, and returns $ r\in\{\accept, \reject\} $ depending on whether the signature is valid or not. The algorithm
  returns $ \accept $ if $ s \cdot \generator = K + c\cdot pk$

## Parameters of instantiation
The above is the standard definition, and in cardano we instantiate it over curve SECP256k1. Moreover, we follow
[BIP-0340](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki). The following are the two specifications
of the above algorithm required for compatibility. Citing literally BIP-0340:
* We use implicit Y coordinates. We encode an elliptic curve point with 32 bytes, and wei mplicitly choose the Y 
  coordinate that is even[6].
* We use tagged hashed of SHA256 for the challenge computation. More precisely, in order to compute `H(K, pk, m)`, 
  one computes `SHA256(SHA256("BIP0340/challenge")||SHA256("BIP0340/challenge") || K || pk || m)`.

More precisely, the following is what is the specification used in the plutus built-in functions:
* The verification key must correspond to the _(x, y)_ coordinates of a point
  on the SECP256k1 curve, where _x, y_ are unsigned integers in big-endian form.
* The verification key must correspond to a result produced by
  [``secp256k1_xonly_pubkey_serialize``](https://github.com/bitcoin-core/secp256k1/blob/master/include/secp256k1_extrakeys.h#L61).
  This implies all of the following:
  * The verification key is 32 bytes long.
  * The bytes of the signature correspond to the _x_ coordinate.
* The input to verify is the message to be checked; this can be of any length,
  and can contain any bytes in any position.
* The signature must correspond to a point _R_ on the SECP256k1 curve, and an
  unsigned integer _s_ in big-endian form.
* The signature must follow the BIP-340 standard for encoding. This implies all
  of the following:
  * The signature is 64 bytes long.
  * The first 32 bytes are the bytes of the _x_ coordinate of _R_, as a
    big-endian unsigned integer.
  * The last 32 bytes are the bytes of `s`.
  ``` 
      ┏━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━┓
      ┃ R <32 bytes> │ s <32 bytes>  ┃
      ┗━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━┛
      <--------- signature ---------->
  ```
