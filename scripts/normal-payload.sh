#!/usr/bin/env bash

set -u

BASE_URL="${BASE_URL:-http://localhost:3000}"
REQUESTS="${REQUESTS:-100}"
DELAY="${DELAY:-0.2}"

echo "Generating normal traffic against $BASE_URL"

for ((i = 1; i <= REQUESTS; i++)); do
    endpoint="/"

    case $((RANDOM % 10)) in
        0) endpoint="/slow" ;;
        1) endpoint="/redirect" ;;
        *) endpoint="/" ;;
    esac

    curl -s -o /dev/null \
        -w "%{http_code} %{time_total}s $endpoint\n" \
        "$BASE_URL$endpoint"

    sleep "$DELAY"
done