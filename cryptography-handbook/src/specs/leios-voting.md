# Cryptography of Leios (Voting Scheme)

This document provides an engineering-level introduction to **Mithril as instantiated in the Leios project**.  
It explains the **flow of operations** (key registration, voting, certification, verification), the **committee model**, and provides a **certificate size analysis**.  

This Leios version of Mithril relies on **BLS signatures** and introduces a key improvement:  
the use of **persistent and non-persistent voters**. This design keeps certificates compact, typically under 10 KB, while ensuring fairness.

---

## 1. Goal

Mithril certificates prove that *enough stake endorsed a block or snapshot*.  

Key elements:
- **Persistent voters**: large SPOs, stable per epoch, compactly encoded.
- **Non-persistent voters**: smaller SPOs, chosen per block, explicit eligibility proofs.
- **BLS aggregation**: constant-size signatures regardless of committee size.

---

## 2. Committee Model

### 2.1 Persistent voters
- Chosen once per epoch via **Fait Accompli sortition**.  
- Typically high-stake SPOs.  
- **Always eligible** for every block in the epoch.  
- Identified by a compact **epoch-specific 2-byte ID**.  
- Require no eligibility proof.  

### 2.2 Non-persistent voters
- Chosen per endorsement block via **local sortition**.  
- Typically lower-stake SPOs.  
- Identified by a **28-byte pool ID**.  
- Must attach an **eligibility signature** (48 bytes, BLS on election ID).  

👉 **Rationale:** Stake distribution is skewed. Encoding large SPOs as persistent keeps certificates small.  
Non-persistent voters ensure fairness and diversity without dominating size.

---

## 3. Flow of Operations

### 3.1 Key Registration
Each pool registers its voting key and proves control:
- **Pool ID:** 28 bytes  
- **BLS public key (mvk):** 96 bytes (G2, compressed)  
- **Proof of Possession (PoP):** 96 bytes  
- **KES signature:** 448 bytes (binds registration to operational identity)  

**Total ≈ 668 bytes per registration.**

- Registrations are recorded on-chain.  
- Nodes verify PoP to prevent rogue-key attacks.  
- Keys are long-lived; rotation is via re-registration.  
- Domain separation and epoch IDs prevent replay.  

---

### 3.2 Voting

Each eligible voter casts a vote:

**Common fields:**
- Election ID (8 bytes)  
- Endorser block hash (32 bytes)  
- Vote signature (48 bytes, BLS)  

**Persistent-specific:**  
- Epoch-specific ID (2 bytes)  
- **Total ≈ 90 bytes**  

**Non-persistent-specific:**  
- Pool ID (28 bytes)  
- Eligibility signature (48 bytes)  
- **Total ≈ 164 bytes**  

---

### 3.3 Certification (Aggregation)

The aggregator collects votes and builds a certificate:

1. **Election + EB data**: Election ID (8 bytes), EB hash (32 bytes).  
2. **Voter identity**:  
   - Persistent voters → bitset, size = ⌈m / 8⌉ bytes.  
   - Non-persistent voters → explicit Pool IDs, 28 × (n − m) bytes.  
3. **Eligibility proofs**:  
   - Persistent → none.  
   - Non-persistent → BLS signatures, 48 × (n − m) bytes.  
4. **Aggregate signatures**:  
   - 48-byte aggregate on message.  
   - Optional 48-byte aggregate on eligibility proofs.  
5. **Metadata**: ~136 bytes total.  

---

### 3.4 Verification

Verifiers process the certificate:

1. **Persistent voters**: read from bitset, no eligibility check.  
2. **Non-persistent voters**: verify Pool ID and eligibility proof.  
3. **Aggregate signature**: check BLS aggregate signature.  
4. **Threshold rule**: compute total stake, confirm ≥ quorum (e.g., 60%).  

---

## 4. Certificate Size Analysis

Formula: 

```
Cert size ≈ 136 + ⌈m/8⌉ + 76 · (n − m)
```

- `m/8`: bitset for persistent voters.  
- `76`: each non-persistent contributes 28 (ID) + 48 (proof).  

### Example A – 500 seats
- n = 500  
- m = 400 persistent, n − m = 100 non-persistent

```
136 + 400/8 + 76 × 100 = 136 + 50 + 7600 = 7786 bytes ≈ 7.8 KB  
```

✅ Under 10 KB

---

### Example B – 1000 seats
- n = 1000  
- **Keep non-persistent count constant:** n − m = 100 (strategy: as the committee grows, increase persistent seats so that (n−m) stays fixed).  
- Then m = 900 persistent.

```
136 + ⌈900/8⌉ + 76 × 100 = 136 + 113 + 7,600 = 7,849 bytes ≈ 7.9 KB
```

✅ Still under 10 KB

**Remark.** In Leios, as `n` grows, we target a **constant (n−m)** by letting the **persistent ratio rise** with `n` (or by selecting additional persistent seats). Keeping the expensive non‑persistent block roughly constant **flattens certificate size** as the committee scales. This matches the near‑flat behavior observed in the specification plots.

---

## 5. Key Takeaways

- **Persistent voters dominate stake, encoded compactly.**  
- **Non-persistent voters ensure fairness, add 76 bytes each.**  
- **BLS aggregation keeps signatures constant-size.**  
- **Holding (n−m) roughly constant as n grows keeps cert size ≈ constant**.

---

## 6. Relation to General Mithril

### Common elements
- **BLS signatures** with PoP for safe aggregation.  
- **Key registration** with Pool ID, public key, and PoP.  
- **Certificates** contain aggregate signatures and evidence of stake-weighted endorsement.  

### General Mithril protocol
- Structured in three phases: Establishment, Initialization, Operations.  
- Uses a **Merkle-committed registry** (AVK root).  
- Certificates include **Merkle paths** to prove membership.  
- Eligibility determined by **lotteries**.  

### Leios-specific adaptations
- **Persistent vs non-persistent voters**: replaces lottery-based seats with a mixed model.  
- **On-chain registry lookup**: assumes verifiers can directly access the epoch’s registry.  
  - Avoids Merkle paths in certificates.  
  - Optimizes for full-node verifiers rather than stateless clients.  
- **Certificate size optimization**: persistent = bitset, non-persistent = 76 bytes each.  
- **No ZK compression**: relies on design and stake distribution to keep size under 10 KB.  

---

## 7. References
- *BLS Certificates for Leios*, IOG Specification (2025).  
- *Fait Accompli Committee Selection*, IOG Research Paper.  
- *Mithril Protocol*, official docs: [mithril.network](https://mithril.network/doc/mithril/advanced/mithril-protocol/protocol)  

---