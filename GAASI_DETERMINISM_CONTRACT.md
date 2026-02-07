# GAASI Determinism Contract — v1 (Locked)

GAASI — Global Autonomous Agent Survivability Index  
Determinism is a deploy-blocking requirement.

This document defines the *non-negotiable determinism guarantees* of GAASI v1.

---

## 1) Scope

This contract applies to:

- GAASI **v1** evaluations only
- **Verdict determinism** and determinism-dependent artifacts (e.g., evidence hash)

This contract does **not** disclose or constrain proprietary implementation internals, only externally enforceable guarantees.

---

## 2) Determinism Definition (Exact)

GAASI v1 is **deterministic** if and only if:

1. **Identical canonical input → identical verdict**  
2. **Identical canonical input → identical evidence hash** (if returned)
3. The evaluation outcome is **independent** of:
   - wall-clock time
   - randomness
   - execution environment
   - network state
   - non-canonical metadata

GAASI v1 must never produce different verdicts for identical canonical inputs.

---

## 3) Canonical Input Set (What “Identical Input” Means)

“Identical canonical input” is defined as the following tuple:

- `agent_version`
- `agent_id`
- `risk_tier`
- `capabilities` (set-equivalent; ordering must not change meaning)
- `maar_pack_ids` (if provided; set/list interpretation must not change meaning)
- GAASI server-side **version identifier** for v1 behavior (implicit, locked)

Optional fields that are **explicitly non-influential** to survivability logic unless GAASI v1 declares otherwise:

- `environment` (context only)
- `notes` (audit/debug only)

If GAASI v1 consumes any optional field for survivability logic, that field must be upgraded to a canonical input in a new version (v2+), with explicit CI proof.

---

## 4) Prohibited Sources of Entropy (Hard Bans)

GAASI v1 MUST NOT allow verdict-affecting dependence on:

- Wall clock time (timestamps, time windows, “current day” logic)
- Randomness (PRNG, sampling, non-fixed seeds)
- Network state (availability, latency, remote variability)
- Execution environment variance (hostnames, regions, containers, CPU scheduling)
- Non-canonical metadata (headers, request ordering, transport-level differences)
- Model nondeterminism that is not collapsed into a deterministic outcome

If any such factor can influence the verdict, determinism is violated.

---

## 5) Determinism Failure Rule (Deploy-Blocking)

If GAASI v1 detects or enters any **non-deterministic condition**, including but not limited to:

- inconsistent intermediate outcomes for the same canonical input
- unavailable deterministic evaluation path
- inability to produce a stable evidence hash
- any entropy source that cannot be eliminated

then GAASI MUST:

- return verdict: **BLOCKED**
- label the failure cause as: **NON_DETERMINISTIC_STATE**
- log the event for audit

This is a hard safety default: **nondeterminism = not shippable**.

---

## 6) External Guarantee

GAASI v1 determinism is a public, enforceable property:

- It is suitable for CI/CD gating
- It is suitable for audit replay expectations at the “same input → same decision” level
- It cannot be weakened silently without a new version and explicit public proof

---

## 7) Version Lock Statement

This contract is part of **GAASI v1 (Locked)**.

Any change that modifies:
- what constitutes canonical input, or
- what can influence verdicts, or
- determinism guarantees

requires:
- a new version (v2+)
- explicit CI proof
- documented backward-compatibility strategy
