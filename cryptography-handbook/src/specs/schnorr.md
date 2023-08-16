# Schnorr

Schnorr, together with ECDSA, were two new signature algorithms introduced in Plutus during Cardano's Valentine 
upgrade.
MuSig2 is a two-round multi-signature scheme will be integrated to Hydra.

## Generalised specification
This section presents the generalized signature system ECDSA and MuSig2. In the [parameter]
(#parameters-of-instantiation) section, we present the specific parameters used in Cardano and MuSig2 C implementation. 

A Schnorr signature consists of the following three algorithms:
* $ \keygen(1^\secparam) $ takes as input the security parameter $ \secparam $ and returns a key-pair $
  (\secretkey, \vk)$. First, it chooses $ \secretkey\gets Z_{\order} $. Finally, compute
  $ \vk \gets \secretkey \cdot \generator $, and return $ (\secretkey, \vk) $.
* $ \sign(\secretkey, \vk, m) $ takes as input a keypair $ (\secretkey, \vk) $ and a message $ m $, and returns a
  signature $ \signature $. Let $ r \gets Z_{\order} $. Compute $ R = r \cdot \generator$, then compute
  $ c \gets \hash(R, \vk, m)$, and finally compute $s = r + c \cdot \secretkey$. The signature is $ \signature \gets 
  (R, s) $.
* $ \verify(m, \vk, \signature) $ takes as input a message $ m $, a verification key $ \vk $ and a signature
  $ \signature $, and returns $ \result \in\{\accept, \reject\} $ depending on whether the signature is valid or not. 
  The algorithm returns $ \accept $ if $ s \cdot \generator = R + c\cdot \vk$

Let $N$ be the number of signers and $V$ be the number of nonces. A two-round multi-signature scheme MuSig2 that
outputs an ordinary Schnorr signature includes the following steps:

* $ \keygen(1^\secparam) $ takes as input the security parameter $ \secparam $ and returns a key-pair $
  (\secretkey, \vk)$. First, it chooses $ \secretkey\gets Z_{\order} $. Finally, compute
  $ \vk \gets \secretkey \cdot \generator $, and return $ (\secretkey, \vk) $.

* $ \batch(1^\secparam) $ takes as input the security parameter $ \secparam $ and returns $V$ key-pairs $ \{ (nonce, 
  COMM)_{1}, \ldots, (nonce, COMM)_{V} \} $. First, it chooses $ nonce_i \gets Z_{\order} $. Finally, computes
  $ COMM_i \gets nonce_i \cdot \generator $, and returns the list including $ V $ tuples of nonces and commitments.

* $ \aggrpk(\{vk_1, \ldots, vk_N\}, \vk_i)$ takes the list of public keys and the signer's public key, returns the 
  aggregate public key $X$ and $ a_i $. First creates $ L = (\vk_1 || \vk_2 || \ldots || \vk_N) $. Computes 
$a_i = H_{agg}(L || \vk_i)_{i = 1..N}$ to be used in single signature by the signer. 
Finally, generates the aggregate public key by $ X = \Sigma_{i = 1}^{N} (a_i \cdot \vk_i) $.

* $ \aggrcomm(\{ (COMM_{11}, \ldots, COMM_{1V}, \ldots, (COMM_{N1}, \ldots, COMM_{NV})) \})$ takes the list of all 
  signers' commitment lists, returns the list of aggregate commitments.
$ \{COMM_j = (\Sigma_{i = 1}^{V} (COMM_{ij})_{i = 1..N})\}_{j = 1, \ldosts, V} $

* $ \sign(\secretkey_i, \vk_i, m, X, (COMM_{1}, \ldots, COMM_{V}), (nonce_{i1}, \ldots, nonce_{iV})) $ takes as 
  input the keypair of the signer, a message $ m $, aggregate public key, the list of commitments and the list of 
  nonces of the signer. Returns a signature $ \signature $. First, creates $ b = H_{non}(X || (COMM_1 || \ldots || 
  COMM_V) || m) \in Z_{\order}$. Computes $ AGGRCOMM = \Sigma_{i = 1}^{V}(COMM_j^{nonce^{j-1}}) $ and $ c = H_{sig}
  (X || R || m) $. The signature is calculated as $ \signature_i = c  a_i \secretkey_i + \Sigma_{i = 1}^{V}(nonce_
  {ij} b^{j-1})$

* $ \aggrsig(\{ \signature_1, \ldots, \signature_N \}, AGGRCOMM)$ takes the list of all
  signers' single signatures and aggregate commitment, returns the aggregate signature $ (AGGRCOMM, \signature) $ 
  where $ \signature = \Sigma_{i = 1}^{N}(\signature_i) $.

* $ \verify(m, X, \signature, AGGRCOMM) $ takes as input a message $ m $, aggregate verification key $ X $, 
  aggregate signature, and aggregate commitment. Computes $c = H_{sig}(X || AGGRCOMM || m)$ and accepts the signature 
  if $\signature \cdot \generator = AGGRCOMM + c \cdot X$.

## Parameters of instantiation
The above is the standard definition, and in cardano we instantiate it over curve SECP256k1. Moreover, we follow
[BIP-0340](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki). The following are the two specifications
of the above algorithm required for compatibility. Citing literally BIP-0340:
* We use implicit `Y` coordinates. We encode an elliptic curve point with 32 bytes, and we implicitly choose the `Y` 
  coordinate that is even[6].
* We use tagged hashed of SHA256 for the challenge computation. More precisely, in order to compute `H(R, vk, m)`, 
  one computes `SHA256(SHA256("BIP0340/challenge")||SHA256("BIP0340/challenge") || R || vk || m)`.

More precisely, the following is what is the specification used in the plutus built-in functions:
* The verification key must correspond to the `(x, y)` coordinates of a point
  on the SECP256k1 curve, where `x, y` are unsigned integers in big-endian form.
* The verification key must correspond to a result produced by
  [``secp256k1_xonly_pubkey_serialize``](https://github.com/bitcoin-core/secp256k1/blob/master/include/secp256k1_extrakeys.h#L61).
  This implies all of the following:
  * The verification key is 32 bytes long.
  * The bytes of the signature correspond to the `x` coordinate.
* The input to verify is the message to be checked; this can be of any length,
  and can contain any bytes in any position.
* The signature must correspond to a point `R` on the SECP256k1 curve, and an
  unsigned integer `s` in big-endian form.
* The signature must follow the BIP-340 standard for encoding. This implies all the following:
  * The signature is 64 bytes long.
  * The first 32 bytes are the bytes of the `x` coordinate of `R`, as a
    big-endian unsigned integer.
  * The last 32 bytes are the bytes of `s`.
  ``` 
      ┏━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━┓
      ┃ R <32 bytes> │ s <32 bytes>  ┃
      ┗━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━┛
      <--------- signature ---------->
  ```
