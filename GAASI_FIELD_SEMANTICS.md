# GAASI Field Semantics — v1 (Canonical)

This document defines the **exact semantic meaning** of each field in the
GAASI Agent Specification v1.

This file is **non-normative**:
- It does NOT define the schema
- It does NOT change validation behavior
- It does NOT override CI enforcement

The authoritative deploy contract is:
→ `GAASI_AGENT_SPEC.md`

---

## 1. agent_version (REQUIRED)

**Type:** string  
**Current canonical value:** `"1.0"`

### Meaning
Schema version identifier for the GAASI agent declaration.

### Used for
- Forward compatibility
- Deterministic audit replay
- Certificate lineage

### Rules
- Missing → **reject**
- Unknown version → **reject**
- GAASI evaluates strictly against the declared version

---

## 2. agent_id (REQUIRED)

**Type:** string

### Meaning
Stable, globally unique identifier for the autonomous agent.

### Used for
- Evidence binding
- Replay detection
- Certificate lineage
- Survivability history tracking

### Rules
- Must be immutable across deployments
- Changing `agent_id` is treated as a **new agent**
- Missing → **reject**

---

## 3. risk_tier (REQUIRED)

**Type:** enum  
**Allowed values:**
- `standard`
- `high`
- `critical`
- `existential`

### Meaning
Declares the **maximum acceptable failure tolerance** for the agent.

### Semantic interpretation
- `standard` → limited blast radius
- `high` → enterprise-impacting
- `critical` → safety / financial / infrastructure risk
- `existential` → irreversible or systemic harm possible
