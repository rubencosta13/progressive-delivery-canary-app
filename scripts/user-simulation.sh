#!/usr/bin/env bash

set -u

BASE_URL="${BASE_URL:-http://localhost:3000}"
USERS="${USERS:-20}"
REQUESTS="${REQUESTS:-50}"

simulate_user() {
    local user="$1"

    for ((i = 1; i <= REQUESTS; i++)); do
        case $((RANDOM % 10)) in
            0)
                endpoint="/slow"
                ;;
            1)
                endpoint="/flaky"
                ;;
            2)
                endpoint="/404"
                ;;
            3)
                endpoint="/redirect"
                ;;
            4)
                endpoint="/error"
                ;;
            *)
                endpoint="/"
                ;;
        esac

        curl -s -o /dev/null \
            -w "user=$user status=%{http_code} time=%{time_total}s endpoint=$endpoint\n" \
            "$BASE_URL$endpoint"

        sleep "$(awk -v min=0.1 -v max=2 'BEGIN{srand(); print min + rand() * (max-min)}')"
    done
}

echo "Simulating $USERS users"
echo "Requests per user: $REQUESTS"

for ((user = 1; user <= USERS; user++)); do
    simulate_user "$user" &
done

wait

echo "Simulation finished"