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
	exit 1
fi

curl "https://adventofcode.com/2023/day/$day/input" \
	-H 'authority: adventofcode.com' \
	-H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
	-H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
	-H 'cache-control: max-age=0' \
	-H "cookie: session=$SESSION; _ga=GA1.2.1275224903.1701614209; _gid=GA1.2.60517764.1701614209; _gat=1" \
	-H 'dnt: 1' \
	-H "referer: https://adventofcode.com/2023/day/$day" \
	-H 'sec-ch-ua: "Chromium";v="117", "Not;A=Brand";v="8"' \
	-H 'sec-ch-ua-mobile: ?0' \
	-H 'sec-ch-ua-platform: "Linux"' \
	-H 'sec-fetch-dest: document' \
	-H 'sec-fetch-mode: navigate' \
	-H 'sec-fetch-site: same-origin' \
	-H 'sec-fetch-user: ?1' \
	-H 'upgrade-insecure-requests: 1' \
	-H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' \
	--compressed --output "$dir_name/input.txt"

touch "$dir_name/sample.txt"
cp template.go "$dir_name/main.go"
