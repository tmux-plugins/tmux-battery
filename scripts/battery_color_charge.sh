#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
color_charge_primary_tier8=''
color_charge_primary_tier7=''
color_charge_primary_tier6=''
color_charge_primary_tier5=''
color_charge_primary_tier4=''
color_charge_primary_tier3=''
color_charge_primary_tier2=''
color_charge_primary_tier1=''
color_charge_secondary_tier8=''
color_charge_secondary_tier7=''
color_charge_secondary_tier6=''
color_charge_secondary_tier5=''
color_charge_secondary_tier4=''
color_charge_secondary_tier3=''
color_charge_secondary_tier2=''
color_charge_secondary_tier1=''

# script default variables
color_charge_primary_tier8_default='#00ff00'
color_charge_primary_tier7_default='#55ff00'
color_charge_primary_tier6_default='#aaff00'
color_charge_primary_tier5_default='#ffff00'
color_charge_primary_tier4_default='#ffc000'
color_charge_primary_tier3_default='#ff8000'
color_charge_primary_tier2_default='#ff4000'
color_charge_primary_tier1_default='#ff0000'
color_charge_secondary_tier8_default='colour0'
color_charge_secondary_tier7_default='colour0'
color_charge_secondary_tier6_default='colour0'
color_charge_secondary_tier5_default='colour0'
color_charge_secondary_tier4_default='colour0'
color_charge_secondary_tier3_default='colour0'
color_charge_secondary_tier2_default='colour0'
color_charge_secondary_tier1_default='colour0'

# colors are set as script global variables
get_color_charge_settings() {
	color_charge_primary_tier8=$(get_tmux_option "@batt_color_charge_primary_tier8" "$color_charge_primary_tier8_default")
	color_charge_primary_tier7=$(get_tmux_option "@batt_color_charge_primary_tier7" "$color_charge_primary_tier7_default")
	color_charge_primary_tier6=$(get_tmux_option "@batt_color_charge_primary_tier6" "$color_charge_primary_tier6_default")
	color_charge_primary_tier5=$(get_tmux_option "@batt_color_charge_primary_tier5" "$color_charge_primary_tier5_default")
	color_charge_primary_tier4=$(get_tmux_option "@batt_color_charge_primary_tier4" "$color_charge_primary_tier4_default")
	color_charge_primary_tier3=$(get_tmux_option "@batt_color_charge_primary_tier3" "$color_charge_primary_tier3_default")
	color_charge_primary_tier2=$(get_tmux_option "@batt_color_charge_primary_tier2" "$color_charge_primary_tier2_default")
	color_charge_primary_tier1=$(get_tmux_option "@batt_color_charge_primary_tier1" "$color_charge_primary_tier1_default")
	color_charge_secondary_tier8=$(get_tmux_option "@batt_color_charge_secondary_tier8" "$color_charge_secondary_tier8_default")
	color_charge_secondary_tier7=$(get_tmux_option "@batt_color_charge_secondary_tier7" "$color_charge_secondary_tier7_default")
	color_charge_secondary_tier6=$(get_tmux_option "@batt_color_charge_secondary_tier6" "$color_charge_secondary_tier6_default")
	color_charge_secondary_tier5=$(get_tmux_option "@batt_color_charge_secondary_tier5" "$color_charge_secondary_tier5_default")
	color_charge_secondary_tier4=$(get_tmux_option "@batt_color_charge_secondary_tier4" "$color_charge_secondary_tier4_default")
	color_charge_secondary_tier3=$(get_tmux_option "@batt_color_charge_secondary_tier3" "$color_charge_secondary_tier3_default")
	color_charge_secondary_tier2=$(get_tmux_option "@batt_color_charge_secondary_tier2" "$color_charge_secondary_tier2_default")
	color_charge_secondary_tier1=$(get_tmux_option "@batt_color_charge_secondary_tier1" "$color_charge_secondary_tier1_default")
}

print_color_charge() {
	local primary_plane="$1"
	local secondary_plane=""
	if [ "$primary_plane" == "bg" ]; then
		secondary_plane="fg"
	else
		secondary_plane="bg"
	fi
	percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
	if [ $percentage -ge 95 -o "$percentage" == "" ]; then
		# if percentage is empty, assume it's a desktop
		printf "#[$primary_plane=$color_charge_primary_tier8${color_charge_secondary_tier8:+",$secondary_plane=$color_charge_secondary_tier8"}]"
	elif [ $percentage -ge 80 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier7${color_charge_secondary_tier7:+",$secondary_plane=$color_charge_secondary_tier7"}]"
	elif [ $percentage -ge 65 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier6${color_charge_secondary_tier6:+",$secondary_plane=$color_charge_secondary_tier6"}]"
	elif [ $percentage -ge 50 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier5${color_charge_secondary_tier5:+",$secondary_plane=$color_charge_secondary_tier5"}]"
	elif [ $percentage -ge 35 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier4${color_charge_secondary_tier4:+",$secondary_plane=$color_charge_secondary_tier4"}]"
	elif [ $percentage -ge 20 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier3${color_charge_secondary_tier3:+",$secondary_plane=$color_charge_secondary_tier3"}]"
	elif [ $percentage -gt 5 ]; then
		printf "#[$primary_plane=$color_charge_primary_tier2${color_charge_secondary_tier2:+",$secondary_plane=$color_charge_secondary_tier2"}]"
	else
		printf "#[$primary_plane=$color_charge_primary_tier1${color_charge_secondary_tier1:+",$secondary_plane=$color_charge_secondary_tier1"}]"
	fi
}

main() {
	local plane="$1"
	get_color_charge_settings
	print_color_charge "$plane"
}

main $@
