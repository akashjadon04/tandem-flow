#!/usr/bin/env bash
# ==============================================================================
# Tandem Flow: Ping-Pong Loop Prevention Verification
# ==============================================================================
set -euo pipefail

WEBHOOK_URL=${1:-"http://localhost:5678/webhook/sync-ingress"}
MOCK_TASK_ID="task_simulation_$(date +%s)"
ORIGIN_HASH="sha256_mock_hash_001"

echo "🧪 [Step 1] Firing Primary Mutation Event from Notion..."
curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "notion",
    "event": "page_updated",
    "entity_id": "'"$MOCK_TASK_ID"'",
    "payload": {
      "title": "Quarterly Financial Audit",
      "status": "In Progress",
      "priority": "High"
    },
    "origin_fingerprint": "'"$ORIGIN_HASH"'"
  }' | jq . || echo "Request sent."

echo ""
echo "🧪 [Step 2] Simulating Immediate Echo Payload from Downstream System (Todoist)..."
echo "   (This payload carries the same origin fingerprint and should be DROPPED by the echo gate)"

curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "todoist",
    "event": "item:updated",
    "entity_id": "'"$MOCK_TASK_ID"'",
    "payload": {
      "content": "Quarterly Financial Audit",
      "is_completed": false,
      "priority": 4
    },
    "origin_fingerprint": "'"$ORIGIN_HASH"'"
  }' | jq . || echo "Echo payload processed (Verify dropped in n8n execution log)."

echo ""
echo "✅ Loop simulation complete. Verify execution history in n8n UI."
