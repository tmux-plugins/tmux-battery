#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_color() {
	local plane="$1"
	local status="$2"
	if [ "$status" == "discharging" ]; then
		$CURRENT_DIR/battery_color_charge.sh "$plane"
	else
		$CURRENT_DIR/battery_color_status.sh "$plane" "$status"
	fi
}

main() {
	local status="$(battery_status)"
	local plane="$1"
	print_color "$plane" "$status"
}

main $@
