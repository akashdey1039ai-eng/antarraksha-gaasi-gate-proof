#!/usr/bin/env bash
set -euo pipefail

echo "🔐 GAASI Survivability Gate starting..."
IDEMPOTENCY_KEY="${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}"

if [[ -z "${GAASI_API_URL:-}" ]]; then
  echo "❌ GAASI_API_URL not set"
  exit 2
fi

if [[ -z "${GAASI_BEARER_TOKEN:-}" ]]; then
  echo "❌ GAASI_BEARER_TOKEN not set"
  exit 2
fi

if [[ -z "${AGENT_PAYLOAD_PATH:-}" ]]; then
  echo "❌ AGENT_PAYLOAD_PATH not set"
  exit 2
fi

if [[ ! -f "$AGENT_PAYLOAD_PATH" ]]; then
  echo "❌ Agent payload not found at $AGENT_PAYLOAD_PATH"
  exit 2
fi

echo "📄 Using agent payload: $AGENT_PAYLOAD_PATH"

RESPONSE=$(curl -sS -X POST "$GAASI_API_URL" \
  -H "Authorization: Bearer $GAASI_BEARER_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: ${IDEMPOTENCY_KEY}" \
  --data-binary @"$AGENT_PAYLOAD_PATH")

echo "📡 GAASI response:"
echo "$RESPONSE"

VERDICT=$(echo "$RESPONSE" | jq -r '.verdict')

if [[ "$VERDICT" == "BLOCKED" ]]; then
  echo "🚫 GAASI verdict: BLOCKED — failing pipeline"
  exit 1
elif [[ "$VERDICT" == "CONDITIONAL" ]]; then
  echo "⚠️ GAASI verdict: CONDITIONAL — failing pipeline"
  exit 1
elif [[ "$VERDICT" == "CERTIFIED" ]]; then
  echo "✅ GAASI verdict: CERTIFIED — pipeline may proceed"
  exit 0
else
  echo "❌ Unknown verdict: $VERDICT"
  exit 2
fi
