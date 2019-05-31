#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_graph() {
	local percentage=$1
	if [ $percentage -gt 5 ]; then
		printf "▁"
	else
		printf " "
	fi
	if [ $percentage -ge 25 ]; then
		printf "▂"
	else
		printf " "
	fi
	if [ $percentage -ge 50 ]; then
		printf "▄"
	else
		printf " "
	fi
	if [ $percentage -ge 75 ]; then
		printf "▆"
	else
		printf " "
	fi
	if [ $percentage -ge 95 ]; then
		printf "█"
	else
		printf " "
		echo "▇"
	fi
}

main() {
	local percentage=$($CURRENT_DIR/battery_percentage.sh)
	if [ "$(uname)" == "OpenBSD" ]; then
		print_graph ${percentage}
	else
		print_graph ${percentage%?}
	fi
}
main
