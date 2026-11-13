#!/usr/bin/env bash
# ==============================================================================
# Tandem Flow: Real-Time Redis Mutex Inspector
# ==============================================================================
set -euo pipefail

REDIS_CMD=${REDIS_CMD:-"docker exec -i tandem-flow-redis redis-cli"}

echo "🔍 Scanning active Tandem Flow distributed locks..."
LOCK_KEYS=$($REDIS_CMD keys "tf:lock:*" 2>/dev/null || true)

if [ -z "$LOCK_KEYS" ]; then
  echo "✅ No active mutex locks found. System is in resting equilibrium."
  exit 0
fi

echo "Active Sync Mutexes:"
for key in $LOCK_KEYS; do
  val=$($REDIS_CMD get "$key")
  ttl=$($REDIS_CMD ttl "$key")
  echo "  🔒 Key: $key | Held By: $val | TTL Remaining: ${ttl}s"
done
