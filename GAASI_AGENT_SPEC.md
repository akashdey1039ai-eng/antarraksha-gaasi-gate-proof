# GAASI Agent Specification — v1 (Canonical)

**GAASI — Global Autonomous Agent Survivability Index**

GAASI is a deterministic, machine-verifiable survivability index used to decide whether an autonomous AI agent is allowed to deploy.

GAASI returns a **binding verdict**:

- **PASS** → deployment allowed  
- **BLOCKED** → deployment rejected  

This is a **deploy-blocking gate**, not an advisory report.

---

## 1. Design Principles (Non-Negotiable)

- Explicit > implicit  
- Closed schema (unknown keys rejected)  
- Versioned  
- Deterministic parsing  
- CI-safe  
- Machine-verifiable only  

This is **not** a description format.  
This is a **survivability declaration**.

---

## 2. Canonical Request Schema (v1)

### 2.1 JSON Shape

```json
{
  "agent_version": "1.0",
  "agent_id": "string",
  "risk_tier": "standard | high | critical | existential",
  "capabilities": ["string"],

  "environment": {
    "any_key": "any_value"
  },

  "notes": "string",
  "maar_pack_ids": ["string"]
}
