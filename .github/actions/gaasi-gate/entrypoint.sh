#!/usr/bin/env bash
set -euo pipefail

GAASI_API_URL="${GAASI_API_URL:-${INPUT_API_URL:-${INPUT_GAASI_API_URL:-}}}"
GAASI_API_KEY="${GAASI_API_KEY:-${INPUT_API_KEY:-${INPUT_GAASI_API_KEY:-}}}"
GAASI_PAYLOAD_PATH="${GAASI_PAYLOAD_PATH:-${INPUT_AGENT_PAYLOAD_PATH:-${INPUT_GAASI_PAYLOAD_PATH:-gaasi-agent.json}}}"
GAASI_FAIL_ON="${GAASI_FAIL_ON:-${INPUT_FAIL_ON:-${INPUT_GAASI_FAIL_ON:-BLOCKED}}}"
GAASI_TIMEOUT="${GAASI_TIMEOUT:-${INPUT_TIMEOUT_SECONDS:-${INPUT_GAASI_TIMEOUT:-180}}}"

echo ""
echo "============================================"
echo "  ANTARRAKSHA — GAASI Survivability Gate"
echo "============================================"
echo ""

if [ -z "${GAASI_API_URL:-}" ]; then
  echo "::error::GAASI_API_URL not set. Provide api_url input."
  exit 2
fi

if [ -z "${GAASI_API_KEY:-}" ]; then
  echo "::error::GAASI_API_KEY not set. Provide api_key input (use GitHub Secrets)."
  exit 2
fi

PAYLOAD_PATH="$GAASI_PAYLOAD_PATH"
FAIL_ON="$GAASI_FAIL_ON"
TIMEOUT_SECONDS="$GAASI_TIMEOUT"

if [ ! -f "$PAYLOAD_PATH" ]; then
  echo "::error::Agent payload file not found: $PAYLOAD_PATH"
  echo "  Looked for: $(pwd)/$PAYLOAD_PATH"
  exit 1
fi

IDEMPOTENCY_KEY="${GITHUB_RUN_ID:-0}-${GITHUB_RUN_ATTEMPT:-0}"

echo "  Agent payload:    $PAYLOAD_PATH"
echo "  API endpoint:     $GAASI_API_URL"
echo "  Idempotency key:  $IDEMPOTENCY_KEY"
echo "  Timeout:          ${TIMEOUT_SECONDS}s"
echo "  Fail on:          $FAIL_ON"
echo ""

PAYLOAD=$(cat "$PAYLOAD_PATH")
echo "Submitting agent for GAASI evaluation..."
echo ""

HTTP_RESPONSE=$(mktemp)

HTTP_CODE=$(curl -s -o "$HTTP_RESPONSE" -w "%{http_code}" \
  --max-time "$TIMEOUT_SECONDS" \
  --retry 2 \
  --retry-delay 2 \
  --retry-max-time "$TIMEOUT_SECONDS" \
  -X POST "$GAASI_API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $GAASI_API_KEY" \
  -H "Idempotency-Key: $IDEMPOTENCY_KEY" \
  -d "$PAYLOAD" \
  2>&1) || {
    echo "::error::Request failed. The API may be unreachable or the evaluation timed out after ${TIMEOUT_SECONDS}s."
    rm -f "$HTTP_RESPONSE"
    exit 1
  }

BODY=$(cat "$HTTP_RESPONSE")
rm -f "$HTTP_RESPONSE"

if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
  echo "::error::API returned HTTP $HTTP_CODE"
  echo "$BODY"
  exit 1
fi

VERDICT=$(echo "$BODY" | jq -r '.verdict // empty')
GAASI_SCORE=$(echo "$BODY" | jq -r '.gaasi_score // empty')
EVIDENCE_ID=$(echo "$BODY" | jq -r '.evidence_id // empty')
EVIDENCE_HASH=$(echo "$BODY" | jq -r '.evidence_hash // empty')
RUN_ID=$(echo "$BODY" | jq -r '.run_id // empty')
SURVIVAL_RATE=$(echo "$BODY" | jq -r '.survival_rate // empty')
CERTIFICATE_ID=$(echo "$BODY" | jq -r '.certificate_id // empty')
EXPIRES_AT=$(echo "$BODY" | jq -r '.expires_at // empty')

if [ -z "$VERDICT" ]; then
  echo "::error::Could not parse verdict from API response."
  echo "$BODY"
  exit 1
fi

BASE_URL=$(echo "$GAASI_API_URL" | sed 's|/api/survivability-gate/evaluate||')
PUBLIC_VERDICT_URL="${BASE_URL}/v/${EVIDENCE_ID}"

echo "verdict=$VERDICT" >> "$GITHUB_OUTPUT"
echo "gaasi_score=$GAASI_SCORE" >> "$GITHUB_OUTPUT"
echo "evidence_id=$EVIDENCE_ID" >> "$GITHUB_OUTPUT"
echo "evidence_hash=$EVIDENCE_HASH" >> "$GITHUB_OUTPUT"
echo "public_verdict_url=$PUBLIC_VERDICT_URL" >> "$GITHUB_OUTPUT"

echo ""
echo "============================================"
echo "  GAASI VERDICT"
echo "============================================"
echo ""

if [ "$VERDICT" = "CERTIFIED" ]; then
  echo "  Status:         CERTIFIED"
elif [ "$VERDICT" = "CONDITIONAL" ]; then
  echo "  Status:         CONDITIONAL"
elif [ "$VERDICT" = "BLOCKED" ]; then
  echo "  Status:         BLOCKED"
fi

echo "  GAASI Score:    $GAASI_SCORE / 1000"
echo "  Survival Rate:  ${SURVIVAL_RATE}%"
echo "  Run ID:         $RUN_ID"
echo ""
echo "  Certificate:    ${CERTIFICATE_ID:-none}"
echo "  Expires:        ${EXPIRES_AT:-n/a}"
echo ""
echo "  Evidence ID:    $EVIDENCE_ID"
echo "  Evidence Hash:  $EVIDENCE_HASH"
echo ""
echo "  Public Verdict: $PUBLIC_VERDICT_URL"
echo ""
echo "============================================"

FAILED_VECTORS=$(echo "$BODY" | jq -r '.failed_vectors[]? | "    - [\(.code)] \(.label)"')
if [ -n "$FAILED_VECTORS" ]; then
  echo ""
  echo "  Failed Vectors:"
  echo "$FAILED_VECTORS"
  echo ""
fi

if [ "$FAIL_ON" = "NONE" ]; then
  echo "Pipeline gate: PASS (fail_on=NONE, all verdicts accepted)"
  exit 0
fi

if [ "$FAIL_ON" = "BLOCKED" ] && [ "$VERDICT" = "BLOCKED" ]; then
  echo "::error::Agent BLOCKED by GAASI Survivability Gate (score: $GAASI_SCORE). This agent cannot be deployed."
  exit 1
fi

if [ "$FAIL_ON" = "CONDITIONAL" ]; then
  if [ "$VERDICT" = "BLOCKED" ] || [ "$VERDICT" = "CONDITIONAL" ]; then
    echo "::error::Agent $VERDICT by GAASI Survivability Gate (score: $GAASI_SCORE). Only CERTIFIED agents may pass (fail_on=CONDITIONAL)."
    exit 1
  fi
fi

echo "Pipeline gate: PASS"
exit 0
