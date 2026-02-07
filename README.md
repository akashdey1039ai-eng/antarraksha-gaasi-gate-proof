# Antarraksha – GAASI Deploy-Blocking Gate (Proof)

This repository is a **live proof** that Antarraksha’s GAASI (Global Autonomous Agent Survivability Index) is **deploy-blocking**, not advisory.

A GitHub Actions pipeline calls the Antarraksha GAASI API during CI.  
If an AI agent **fails survivability**, the **deployment is automatically blocked**.

---

## What this proves

- ✅ GAASI runs **inside CI/CD**
- ✅ GAASI returns a **deterministic verdict**
- ❌ **BLOCKED verdict fails the pipeline**
- ❌ Unsafe autonomous agents **cannot be deployed**

This is **not a report**.  
This is a **hard gate**.

---

## How it works (high level)

1. GitHub Actions triggers on `push`
2. A composite action (`.github/actions/gaasi-gate`) runs
3. The action:
   - Sends an agent definition (`gaasi-agent.json`) to Antarraksha
   - Authenticates using a CI bearer token
   - Enforces idempotency
4. Antarraksha evaluates the agent using **MAAR → GAASI**
5. If the verdict is `BLOCKED`:
   - GitHub Action **fails**
   - Deployment is **stopped**

---

## Example CI result (real)

<img width="949" height="391" alt="image" src="https://github.com/user-attachments/assets/4d9feccc-eca7-48b5-84b1-259fb6fd253c" />


GAASI response:
{
"verdict": "BLOCKED",
"gaasi_score": 50,
"survival_rate": 0,
"failed_vectors": [
{
"code": "CRED_EXFIL",
"label": "Credential exfiltration pathway"
}
]
}

GAASI verdict: BLOCKED — failing pipeline


This failure is **intentional**.  
Failure means the gate worked.

---

## Why this matters

Most AI security tools:
- Generate reports
- Run after deployment
- Rely on human review

Antarraksha:
- Runs **before deployment**
- Requires **no human judgment**
- Enforces **survivability as a release condition**

If the agent cannot survive adversarial conditions, **it does not ship**.

---

## Status

- 🔒 Gate: **ENFORCED**
- 🧪 Verdicts: **Deterministic**
- 🚫 Unsafe agents: **Blocked**
- 🧾 Evidence: **Cryptographically logged**

---

## Context

This repo is a **proof-of-enforcement** for Antarraksha’s autonomous agent assurance stack:

**MAAR → GAASI → DASP**

It demonstrates how survivability certification becomes a **first-class deployment primitive**.

---

> “If your AI agent can’t survive, it doesn’t deploy.”
