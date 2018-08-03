#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

short=false

get_remain_settings() {
	short=$(get_tmux_option "@batt_remain_short" false)
}

battery_discharging() {
	local status="$(battery_status)"
	[[ $status =~ (discharging) ]]
}

battery_charged() {
	local status="$(battery_status)"
	[[ $status =~ (charged) ]]
}

pmset_battery_remaining_time() {
	local status="$(pmset -g batt)"
	if echo $status | grep 'no estimate' >/dev/null 2>&1; then
		if $short; then
			echo '~?:??'
		else
			echo '- Calculating estimate...'
		fi
	else
		local remaining_time="$(echo $status | grep -o '[0-9]\{1,2\}:[0-9]\{1,2\}')"
		if battery_discharging; then
			if $short; then
				echo $remaining_time | awk '{printf "~%s", $1}'
			else
				echo $remaining_time | awk '{printf "- %s left", $1}'
			fi
		elif battery_charged; then
			if $short; then
				echo $remaining_time | awk '{printf "charged", $1}'
			else
				echo $remaining_time | awk '{printf "fully charged", $1}'
			fi
		else
			if $short; then
				echo $remaining_time | awk '{printf "~%s", $1}'
			else
				echo $remaining_time | awk '{printf "- %s till full", $1}'
			fi
		fi
	fi
}

print_battery_remain() {
	if command_exists "pmset"; then
		pmset_battery_remaining_time
	elif command_exists "upower"; then
		battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
		if is_chrome; then
			if battery_discharging; then
				upower -i $battery | grep 'time to empty' | awk '{printf "- %s %s left", $4, $5}'
			else
				upower -i $battery | grep 'time to full' | awk '{printf "- %s %s till full", $4, $5}'
			fi
		else
			upower -i $battery | grep -E '(remain|time to empty)' | awk '{print $(NF-1)}'
		fi
	elif command_exists "acpi"; then
		acpi -b | grep -m 1 -Eo "[0-9]+:[0-9]+:[0-9]+"
	fi
}

print_battery_full() {
	if !$short; then
		return
	fi

	if command_exists "pmset"; then
		pmset_battery_remaining_time
	elif command_exists "upower"; then
		battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
		upower -i $battery | grep 'time to full' | awk '{printf "- %s %s till full", $4, $5}'
	fi
}

main() {
	get_remain_settings
	if battery_discharging; then
		print_battery_remain
	else
		print_battery_full
	fi
}
main
