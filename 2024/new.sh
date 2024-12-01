#!/usr/bin/env bash

# shellcheck source=./.env
source ./.env

day=$1
formatted_day=$(printf "%02d" "$1")

dir_name="day$formatted_day"

if [ -z "$day" ]; then
  echo "Usage: $0 <day>"
  echo "Example: $0 1"
  exit 1
fi

if ! mkdir "$dir_name" &>/dev/null; then
  echo "Failed to create directory"
  echo "Continuing in 3 seconds..."
  sleep 3
fi

curl "https://adventofcode.com/2024/day/$day/input" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-GB,en;q=0.9,en-US;q=0.8' \
  -H 'cache-control: max-age=0' \
  -H "cookie: session=$SESSION" \
  -H 'dnt: 1' \
  -H 'priority: u=0, i' \
  -H 'referer: https://adventofcode.com/2024/day/1' \
  -H 'sec-ch-ua: "Microsoft Edge";v="131", "Chromium";v="131", "Not_A Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0' \
  --compressed --output "$dir_name/input.txt"
