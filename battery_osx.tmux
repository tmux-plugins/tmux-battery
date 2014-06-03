#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

battery_percentage="#($CURRENT_DIR/scripts/battery_percentage_osx.sh)"
battery_icon="#($CURRENT_DIR/scripts/battery_icon_osx.sh)"
battery_percentage_interpolation="\#{battery_percentage}"
battery_icon_interpolation="\#{battery_icon}"

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local string=$1
	local percentage_interpolated=${string/$battery_percentage_interpolation/$battery_percentage}
	local all_interpolated=${percentage_interpolated/$battery_icon_interpolation/$battery_icon}
	echo $all_interpolated
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
}
main
