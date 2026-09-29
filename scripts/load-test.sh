#!/usr/bin/env bash

set -u

BASE_URL="${BASE_URL:-http://localhost:3000}"
REQUESTS="${REQUESTS:-1000}"
CONCURRENCY="${CONCURRENCY:-20}"

echo "Load test"
echo "URL: $BASE_URL"
echo "Requests: $REQUESTS"
echo "Concurrency: $CONCURRENCY"

seq "$REQUESTS" |
xargs -P "$CONCURRENCY" -I {} \
    curl -s -o /dev/null \
    -w "%{http_code} %{time_total}s\n" \
    "$BASE_URL/"