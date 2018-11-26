#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

color_full_charge_default="#[bg=green]"
color_high_charge_default="#[bg=yellow]"
color_medium_charge_default="#[bg=colour208]" # orange
color_low_charge_default="#[bg=red]"
color_charging_default="#[bg=green]"

color_full_charge=""
color_high_charge=""
color_medium_charge=""
color_low_charge=""
color_charging=""

get_charge_color_settings() {
    color_full_charge=$(get_tmux_option "@batt_color_full_charge" "$color_full_charge_default")
    color_high_charge=$(get_tmux_option "@batt_color_high_charge" "$color_high_charge_default")
    color_medium_charge=$(get_tmux_option "@batt_color_medium_charge" "$color_medium_charge_default")
    color_low_charge=$(get_tmux_option "@batt_color_low_charge" "$color_low_charge_default")
    color_charging=$(get_tmux_option "@batt_color_charging" "$color_charging_default")
}

print_battery_status_bg() {
    # Call `battery_percentage.sh`.
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
    status=$(battery_status | awk '{print $1;}')
    if [ $status == 'charging' ]; then
	printf $color_charging
    elif [ $percentage -eq 100 ]; then
        printf $color_full_charge
    elif [ $percentage -le 99 -a $percentage -ge 51 ];then
        printf $color_high_charge
    elif [ $percentage -le 50 -a $percentage -ge 16 ];then
        printf $color_medium_charge
    elif [ "$percentage" == "" ];then
        printf $color_full_charge_default  # assume it's a desktop
    else
        printf $color_low_charge
    fi
}

main() {
    get_charge_color_settings
	print_battery_status_bg
}
main
