# GAASI Verification Contract — v1 (Locked)

GAASI — Global Autonomous Agent Survivability Index  
Independent verification is a first-class guarantee.

---

## 1. Purpose

This document defines how GAASI v1 decisions can be **independently verified**
by third parties without relying on Antarraksha’s internal systems.

Verification does NOT require:
- access to GAASI internals
- access to MAAR logic
- trust in Antarraksha infrastructure

---

## 2. Verifiable Artifacts

For every GAASI v1 evaluation, the following artifacts are sufficient
to verify the decision:

- Canonical agent declaration (GAASI v1 schema)
- GAASI version identifier (v1)
- Final verdict (`PASS` or `BLOCKED`)
- Cryptographic evidence hash

No additional context is required.

---

## 3. Verification Guarantees

A verifier MUST be able to confirm:

- The verdict corresponds to the declared input
- The evidence hash matches the canonical input
- The evaluation claims GAASI v1 semantics
- The verdict has not been altered

Verification is **binary**:
- valid
- invalid

There are no partial or subjective outcomes.

---

## 4. What Verification Does NOT Require

Verification explicitly does NOT require:

- Re-running GAASI
- Reproducing adversarial simulations
- Inspecting MAAR internals
- Human interpretation or judgment

Verification operates on **evidence integrity**, not model behavior.

---

## 5. Failure Mode (Deploy-Blocking)

If a GAASI evaluation:

- cannot be independently verified
- lacks sufficient evidence
- produces unverifiable artifacts

The evaluation MUST be treated as:

- verdict: **BLOCKED**
- reason: **VERIFICATION_FAILURE**

No override paths exist.

---

## 6. Certification Readiness

Because GAASI v1 decisions are independently verifiable, they are suitable for:

- compliance audits
- regulatory review
- contractual enforcement
- certification programs

This property is mandatory for GAASI v1.

---

## 7. Version Lock

Any change to:

- verification inputs
- verification rules
- evidence requirements

requires:
- GAASI v2
- explicit CI proof
- public documentation

GAASI v1 verification semantics are immutable.
