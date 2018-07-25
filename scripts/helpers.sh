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
	[ $(uname) == "Darwin" ]
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
		local battery
		battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
		upower -i $battery | awk '/state/ {print $2}'
	elif command_exists "acpi"; then
		acpi -b | awk '{gsub(/,/, ""); print tolower($3); exit}'
	elif command_exists "termux-battery-status"; then
		termux-battery-status | jq -r '.status' | awk '{printf("%s%", tolower($1))}'
	fi
}
