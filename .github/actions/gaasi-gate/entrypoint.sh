#!/usr/bin/env bash
set -euo pipefail

echo "🔒 GAASI Survivability Gate starting..."

: "${GAASI_API_URL:?❌ GAASI_API_URL not set}"
: "${GAASI_API_KEY:?❌ GAASI_API_KEY not set}"
: "${GAASI_PAYLOAD_PATH:?❌ GAASI_PAYLOAD_PATH not set}"

GAASI_FAIL_ON="${GAASI_FAIL_ON:-BLOCKED}"
GAASI_TIMEOUT="${GAASI_TIMEOUT:-30}"

if [ ! -f "$GAASI_PAYLOAD_PATH" ]; then
  echo "❌ Payload file not found: $GAASI_PAYLOAD_PATH"
  exit 2
fi

echo "📄 Payload: $GAASI_PAYLOAD_PATH"
echo "🎯 Fail on verdict: $GAASI_FAIL_ON"
echo "⏱️ Timeout: $GAASI_TIMEOUT seconds"

RESP=$(curl -sS --fail --max-time "$GAASI_TIMEOUT" \
  -H "Authorization: Bearer $GAASI_API_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @"$GAASI_PAYLOAD_PATH" \
  "$GAASI_API_URL")

echo "✅ GAASI response: $RESP"

# Minimal verdict extraction (expects JSON contains "verdict":"PASS" or "BLOCKED")
VERDICT=$(echo "$RESP" | grep -oE '"verdict"\s*:\s*"[^"]+"' | head -n1 | cut -d'"' -f4 || true)

if [ -z "${VERDICT}" ]; then
  echo "❌ Could not parse verdict from response."
  exit 2
fi

echo "📌 Verdict: $VERDICT"

if [ "$VERDICT" = "$GAASI_FAIL_ON" ]; then
  echo "🚫 Deployment blocked by GAASI (verdict=$VERDICT)"
  exit 1
fi

echo "✅ GAASI gate passed (verdict=$VERDICT)"
