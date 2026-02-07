# GAASI Audit Replay & Evidence Contract — v1 (Locked)

GAASI — Global Autonomous Agent Survivability Index  
Audit replay and evidence binding are deploy-blocking guarantees.

---

## 1. Purpose

This document defines the **audit replay and evidence guarantees** of GAASI v1.

It answers a single question:

> “Can GAASI’s decision be independently replayed and verified later?”

For GAASI v1, the answer is **YES — or deployment is blocked**.

---

## 2. Evidence Generation (Mandatory)

For every GAASI v1 evaluation, GAASI MUST generate:

- A **cryptographic evidence hash**
- Deterministically derived from:
  - canonical agent input
  - GAASI v1 behavior
  - evaluation outcome

Evidence generation is **mandatory**, regardless of verdict.

---

## 3. Evidence Binding (Non-Negotiable)

Each evidence record is **immutably bound** to:

- `agent_id`
- `agent_version`
- Declared `risk_tier`
- Declared `capabilities`
- `maar_pack_ids` (if provided)
- GAASI version identifier (v1)
- Final verdict (`PASS` or `BLOCKED`)

Evidence MUST NOT be reusable across:
- agents
- versions
- environments
- evaluations

---

## 4. Audit Replay Guarantee

GAASI v1 guarantees:

- Identical canonical input → identical verdict
- Identical canonical input → identical evidence hash
- Replay does **not** require:
  - human judgment
  - external context
  - mutable state
  - time-based interpretation

Replay correctness is evaluated at the **decision level**, not internal mechanics.

---

## 5. Immutability Rules

Once generated:

- Evidence MUST NOT be:
  - edited
  - replaced
  - overridden
  - re-scored
- Verdicts MUST NOT be:
  - reclassified
  - softened
  - bypassed

Any attempt to mutate evidence or verdict **invalidates the evaluation**.

---

## 6. Failure Mode (Deploy-Blocking)

If GAASI v1 cannot:

- generate evidence
- bind evidence deterministically
- replay the verdict
- verify evidence integrity

GAASI MUST return:

- verdict: **BLOCKED**
- reason: **AUDIT_INTEGRITY_FAILURE**

No exception paths exist.

---

## 7. Public Assurance Statement

GAASI v1 audit guarantees are:

- deterministic
- machine-verifiable
- CI/CD enforceable
- suitable for certification and compliance use

These guarantees are part of **GAASI v1 (Locked)**.

---

## 8. Version Lock

Any change to:

- evidence structure
- binding rules
- replay semantics

requires:

- GAASI v2
- explicit CI proof
- documented backward-compatibility strategy
