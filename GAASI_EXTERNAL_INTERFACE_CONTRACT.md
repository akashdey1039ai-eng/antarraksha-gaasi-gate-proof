# GAASI External Interface Contract — v1 (Locked)

GAASI — Global Autonomous Agent Survivability Index  
This document defines the minimal external interface exposed by GAASI v1.

---

## 1. Purpose

This contract defines how external systems interact with GAASI v1
without requiring knowledge of internal implementation details.

It establishes GAASI as a **stable infrastructure primitive**.

---

## 2. Interface Scope

GAASI v1 exposes exactly one logical operation:

> **Evaluate an autonomous agent declaration and return a binding verdict.**

GAASI v1 does NOT expose:
- configuration interfaces
- tuning parameters
- override mechanisms
- partial evaluation modes

---

## 3. Required Inputs

An external system MUST provide:

- A valid **GAASI v1 agent declaration**  
  (as defined in `GAASI_AGENT_SPEC.md`)

No additional inputs are permitted to influence evaluation.

---

## 4. Required Outputs

GAASI v1 MUST return:

- `verdict` — one of:
  - `PASS`
  - `BLOCKED`
- `evidence_hash` — cryptographic proof of evaluation
- `gaasi_version` — always `v1`

Optional metadata MAY be returned but MUST NOT affect interpretation.

---

## 5. Error Semantics

GAASI v1 recognizes only two outcome classes:

1. **Valid evaluation**
   - PASS or BLOCKED returned
2. **Invalid evaluation**
   - Treated as BLOCKED

There is no “soft failure”, “warning”, or “inconclusive” state.

---

## 6. Idempotency Guarantee

For identical canonical inputs:

- The external interface MUST return:
  - identical verdict
  - identical evidence hash

Repeated submissions MUST NOT create divergent outcomes.

---

## 7. Non-Configurability

External systems:
- MUST NOT influence thresholds
- MUST NOT adjust evaluation scope
- MUST NOT bypass GAASI enforcement

GAASI v1 behavior is globally fixed.

---

## 8. Integration Targets

This interface is suitable for:

- CI/CD pipelines
- Platform deployment gates
- Cloud infrastructure controls
- Certification and compliance systems

GAASI v1 is environment-agnostic.

---

## 9. Failure Mode (Deploy-Blocking)

If the external interface:

- cannot complete evaluation
- returns ambiguous output
- violates determinism or idempotency

The result MUST be treated as:

- verdict: **BLOCKED**
- reason: **INTERFACE_INTEGRITY_FAILURE**

---

## 10. Version Lock

Any change to:
- input requirements
- output semantics
- interface guarantees

requires:
- GAASI v2
- explicit CI proof
- public documentation

GAASI v1 external interface semantics are immutable.
