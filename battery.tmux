#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

declare -A interpolation

interpolation["\#{battery_percentage}"]="#($CURRENT_DIR/scripts/battery_percentage.sh)"
interpolation["\#{battery_remain}"]="#($CURRENT_DIR/scripts/battery_remain.sh)"
interpolation["\#{battery_icon}"]="#($CURRENT_DIR/scripts/battery_icon.sh)"
interpolation["\#{battery_status_bg}"]="#($CURRENT_DIR/scripts/battery_status_bg.sh)"
interpolation["\#{battery_graph}"]="#($CURRENT_DIR/scripts/battery_graph.sh)"

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local all_interpolated="$1"
	for key in "${!interpolation[@]}"; do
		all_interpolated=${all_interpolated/$key/${interpolation[$key]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
