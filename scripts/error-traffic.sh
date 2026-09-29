#!/usr/bin/env bash

set -u

BASE_URL="${BASE_URL:-http://localhost:3000}"
REQUESTS="${REQUESTS:-200}"

echo "Generating error traffic against $BASE_URL"

for ((i = 1; i <= REQUESTS; i++)); do
    case $((RANDOM % 4)) in
        0)
            endpoint="/500"
            ;;
        1)
            endpoint="/404"
            ;;
        2)
            endpoint="/error"
            ;;
        3)
            endpoint="/flaky"
            ;;
    esac

    curl -s -o /dev/null \
        -w "%{http_code} %{time_total}s $endpoint\n" \
        "$BASE_URL$endpoint"

    sleep 0.1
done