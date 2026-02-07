# GAASI Rejection Rules — v1 (Canonical)

This document defines the **explicit rejection conditions** enforced by
the GAASI Deploy-Blocking Gate.

GAASI is a **hard gate**.
Any rejection results in:

→ **BLOCKED verdict**
→ **CI failure**
→ **Deployment halted**

This is not advisory behavior.

---

## Authoritative Scope

- Applies to **GAASI Agent Specification v1**
- Enforced during CI via GAASI API
- Deterministic and replayable

Schema authority:
→ `GAASI_AGENT_SPEC.md`

Field meaning reference:
→ `GAASI_FIELD_SEMANTICS.md`

---

## 1. Schema-Level Rejections (Immediate)

GAASI will **immediately reject** requests containing any of the following.

### 1.1 Unknown Top-Level Keys

GAASI enforces a **closed schema**.

❌ Any top-level key not defined in v1 → **reject**

Examples (observed in CI audit):
- `agent_name`
- `deployment_scope`
- `tools`
- `description`
- `permissions`
- `agent_type`

These fields are **not part of v1**.

---

### 1.2 Missing Required Fields

The following fields are mandatory:

- `agent_version`
- `agent_id`
- `risk_tier`
- `capabilities`

❌ Missing any required field → **reject**

---

### 1.3 Invalid Enum Values

Currently enforced enums:

- `risk_tier`:  
  `standard | high | critical | existential`

❌ Any other value → **reject**

---

### 1.4 Incorrect Field Types

Each field must match its expected type.

Examples:
- `capabilities` must be an array
- `environment` must be an object
- `maar_pack_ids` must be an array of strings

❌ Type mismatch → **reject**

---

### 1.5 Empty Capability Set

Capabilities must be explicitly declared.

❌ `capabilities: []` → **reject**

Rationale:
An agent with no declared capabilities cannot be evaluated meaningfully
and is treated as unsafe by default.

---

## 2. Versioning Rejections

### 2.1 Unknown Schema Version

- Current supported version: `"1.0"`

❌ Unknown `agent_version` → **reject**

---

### 2.2 Missing Version Declaration

❌ Missing `agent_version` → **reject**

GAASI does not infer versions.

---

## 3. Semantic Rejections (Evaluation-Time)

These rejections occur **after schema validation**, during survivability
evaluation.

### 3.1 Survivability Failure

If the agent fails GAASI survivability thresholds:

→ Verdict: **BLOCKED**

This includes (non-exhaustive):
- Credential exfiltration paths
- Irreversible failure modes
- High-risk autonomous escalation
- Failure under adversarial MAAR pressure

---

### 3.2 Risk Tier Threshold Violations

GAASI enforces stricter thresholds for higher `risk_tier`.

Rules:
- GAASI never downgrades declared risk
- Higher tier → higher bar
- Failure at declared tier → **BLOCKED**

---

## 4. Explicit Non-Rejections (Clarified)

The following **do NOT cause rejection by themselves**:

- Presence of `environment` keys
- Presence or absence of `notes`
- Absence of `maar_pack_ids`
- Additional keys *inside* `environment`

These are either opaque or informational.

---

## 5. Determinism Guarantee

For any rejection:

- Same input → same rejection reason
- Same input → same evidence hash
- Same input → same CI outcome

Rejections are:
- Cryptographically logged
- Replayable for audit
- Certificate-defensible

---

## Final Principle

> If an autonomous agent cannot survive adversarial conditions,
> it does not deploy.

GAASI enforces this **without exception**.
