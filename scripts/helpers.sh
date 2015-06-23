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

is_cygwin() {
	[[ $(uname) =~ "CYGWIN" ]]
}

wimc_get_BatteryStatus() {
	cmd /c wmic.exe /NameSpace:"\\\\root\\WMI" Path BatteryStatus get $1 | sed -e '2!d' -e 's/[ \t\r\n]*//g'
}

wimc_get_Battery() {
	WMIC Path Win32_Battery get $1 | sed -e '2!d' -e 's/[ \t\r\n]*//g'
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

battery_status() {
	if is_cygwin; then
		if [[ `wimc_get_BatteryStatus charging` == "TRUE" ]]; then
			echo "charging"
		elif [[ `wimc_get_BatteryStatus discharging` == "TRUE" ]]; then
			echo "discharging"
		elif [[ `wimc_get_BatteryStatus discharging` == "FALSE" && `wimc_get_BatteryStatus charging` == "FALSE" ]]; then
			echo "charged"
		elif [[ `wimc_get_BatteryStatus PowerOnline` == "TRUE" ]]; then
			echo "attached"
		fi
	else
		if command_exists "pmset"; then
			pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
		elif command_exists "upower"; then
			# sort order: attached, charging, discharging
			for battery in $(upower -e | grep battery); do
				upower -i $battery | grep state | awk '{print $2}'
			done | sort | head -1
		elif command_exists "acpi"; then
			acpi -b | grep -oi 'discharging' | awk '{print tolower($0)}'
		fi
	fi
}
