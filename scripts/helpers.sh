get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[[ "$(uname)" == "Darwin" ]]
}

is_chrome() {
	chrome="/sys/class/chromeos/cros_ec"
	if [ -d "$chrome" ]; then
		return 0
	else
		return 1
	fi
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

battery_status() {
	if command_exists "pmset"; then
		pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
	elif command_exists "upower"; then
		# sort order: attached, charging, discharging
		for battery in $(upower -e | grep battery); do
			upower -i "$battery" | grep state | awk '{print $2}'
		done | sort | head -1
	elif command_exists "acpi"; then
		acpi -b | grep -oi 'discharging' | awk '{print tolower($0)}'
	fi
}

ac_online() {
	local toggle_plug_status="$(get_tmux_option "@batt_toggle_plug_status" "false")"
	[[ "${toggle_plug_status}" == "false" ]] && return 1

	if command_exists "upower"; then
		[[ "$(upower -i /org/freedesktop/UPower/devices/line_power_AC | awk -F: '/online/ {gsub(/ /, "", $NF); print $NF}')" == "yes" ]]
	elif command_exists "acpi"; then
		acpi -a | grep -q 'on-line'
	elif command_exists "pmset"; then
		pmset -g batt | egrep -q "^Now draining from.*AC Power"
	elif [[ -e /sys/class/power_supply/AC/online ]]; then
		[[ "$(cat /sys/class/power_supply/AC/online)" -eq 1 ]]
	else
		return 0
	fi
}
