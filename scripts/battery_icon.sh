#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_icon() {
	local status=$1
	if [ "$status" == "discharging" ]; then
		$CURRENT_DIR/battery_icon_charge.sh
	else
		$CURRENT_DIR/battery_icon_status.sh "$status"
	fi
}

main() {
	local status=$(battery_status)
	print_icon "$status"
}

main
