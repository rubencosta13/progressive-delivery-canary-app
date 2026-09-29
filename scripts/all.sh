#!/usr/bin/env bash

set -u

BASE_URL="${BASE_URL:-http://localhost:3000}"

echo "Starting canary demonstration"
echo "Target: $BASE_URL"

echo
echo "=== Normal traffic ==="
REQUESTS=100 ./scripts/normal-traffic.sh

echo
echo "=== Error traffic ==="
REQUESTS=200 ./scripts/error-traffic.sh

echo
echo "=== User simulation ==="
USERS=20 REQUESTS=50 ./scripts/user-simulation.sh

echo
echo "=== Load test ==="
REQUESTS=2000 CONCURRENCY=30 ./scripts/load-test.sh

echo
echo "Demo complete"