#!/usr/bin/env bash
# ==============================================================================
# Tandem Flow: Emergency Lock Eviction & Deadlock Recovery
# ==============================================================================
set -euo pipefail

REDIS_CMD=${REDIS_CMD:-"docker exec -i tandem-flow-redis redis-cli"}

echo "⚠️  Flushing stale synchronization locks..."
KEYS=$($REDIS_CMD keys "tf:lock:*" 2>/dev/null || true)

if [ -z "$KEYS" ]; then
  echo "✅ No locks to evict."
  exit 0
fi

for key in $KEYS; do
  $REDIS_CMD del "$key" >/dev/null
  echo "  🗑️ Evicted lock: $key"
done

echo "✅ All sync mutex locks cleared successfully."
