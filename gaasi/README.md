# GAASI v1 — Global Autonomous Agent Survivability Index

GAASI is a **deploy-blocking, machine-verifiable survivability gate** for autonomous AI agents.

It determines—**before deployment**—whether an autonomous agent is allowed to ship.

GAASI is not advisory.
GAASI is not a report.
GAASI is a hard gate.

If an agent fails survivability, **deployment is blocked**.

---

## What GAASI Decides

GAASI returns a **binding verdict**:

- **PASS** → deployment allowed
- **BLOCKED** → deployment rejected (CI fails)

This decision is:
- Deterministic
- Replayable
- Cryptographically evidenced
- Enforced inside CI/CD

---

## GAASI v1 Canonical Documents

GAASI v1 is defined by **three authoritative documents**.

These MUST be read together.

---

### 1️⃣ GAASI Agent Specification (Schema)

**File:** `GAASI_AGENT_SPEC.md`

Defines:
- The **exact JSON request shape**
- Required vs optional fields
- Closed schema rules
- Version locking

This document answers:
> *“What must an agent declare to be evaluated?”*

This is the **only allowed input format** for GAASI v1.

---

### 2️⃣ GAASI Field Semantics

**File:** `GAASI_FIELD_SEMANTICS.md`

Defines:
- Exact meaning of every field
- How GAASI interprets declarations
- What affects survivability logic vs what is ignored
- Risk-tier semantics and guarantees

This document answers:
> *“What does each field mean to GAASI?”*

This is **behavioral**, not schema.

---

### 3️⃣ GAASI Rejection Rules

**File:** `GAASI_REJECTION_RULES.md`

Defines:
- All explicit rejection conditions
- Schema-level failures
- Versioning failures
- Survivability failures
- CI-observed rejected keys

This document answers:
> *“Exactly why does GAASI say NO?”*

Every rejection is deterministic and logged.

---

## Evaluation Pipeline (v1)

1. **Schema validation**
   - Closed schema enforced
   - Unknown keys rejected
   - Required fields enforced

2. **Semantic binding**
   - Risk tier locked
   - Capabilities bound
   - Context ingested (if provided)

3. **Adversarial evaluation**
   - MAAR-driven failure synthesis
   - Survivability scoring
   - Threshold enforcement

4. **Verdict issued**
   - PASS or BLOCKED
   - Evidence hash generated
   - CI gate enforced

---

## Versioning Policy

- GAASI v1 is **locked**
- Any schema expansion requires:
  - New version (v2)
  - Explicit CI proof
  - Backward compatibility strategy

GAASI never silently changes behavior.

GAASI v1 behavior is immutable once released.

---

## Design Principles (Non-Negotiable)

- Explicit > implicit
- Closed schemas
- Deterministic parsing
- CI-safe
- Machine-verifiable only
- No human judgment paths

---

## Final Statement

> If an autonomous agent cannot survive adversarial conditions,
> it does not deploy.

GAASI enforces this **globally, deterministically, and before release**.

GAASI v1 is enforced via live CI gates and cannot be overridden.

