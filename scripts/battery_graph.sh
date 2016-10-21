#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_graph() {
	if [ -z "$1" ]; then
		echo ""
	elif [ "$1" -lt "20" ]; then
		echo "▁"
	elif [ "$1" -lt "40" ]; then
		echo "▂"
	elif [ "$1" -lt "60" ]; then
		echo "▃"
	elif [ "$1" -lt "80" ]; then
		echo "▅"
	else
		echo "▇"
	fi
}

main() {
	local percentage=$($CURRENT_DIR/battery_percentage.sh)
	print_graph ${percentage%?}
}
main
