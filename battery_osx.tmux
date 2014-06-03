#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

battery_percentage="#($CURRENT_DIR/scripts/battery_percentage_osx.sh)"
battery_icon="#($CURRENT_DIR/scripts/battery_icon_osx.sh)"
battery_percentage_interpolation="&bp"
battery_icon_interpolation="&bi"

get_status_right() {
	local status_right=$(tmux show-option -gv status-right)
	echo $status_right
}

do_interpolation() {
	local string=$1
	local percentage_interpolated=${string/$battery_percentage_interpolation/$battery_percentage}
	local all_interpolated=${percentage_interpolated/$battery_icon_interpolation/$battery_icon}
	echo $all_interpolated
}

insert_battery_commands() {
	local string=$1
	if needs_batt_interpolation "$string"; then
		do_interpolation "$string"
	fi
}

update_tmux_status_right() {
	local new_status=$1
	tmux set -gq status-right "$new_status"
}

main() {
	local status_right=$(get_status_right)
	local new_status_right=$(insert_battery_commands "$status_right")
	update_tmux_status_right "$new_status_right"
}
main
