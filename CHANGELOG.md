# Changelog

### v2.0.0, 2025-12-30
- Added `#{battery_charging_watts}` format string for displaying current watts supplied on macOS
- Added `#{battery_color_bg}`, `#{battery_color_fg}` format strings for dynamic color based on charge/status
- Added `#{battery_color_charge_bg}`, `#{battery_color_charge_fg}` for colors based solely on charge level
- Added `#{battery_color_status_bg}`, `#{battery_color_status_fg}` for colors based solely on battery status
- Added `#{battery_icon_charge}`, `#{battery_icon_status}` for granular icon control
- Added 8-tier charge level icons and colors with full customization support
- Added `#{battery_graph}` to display battery as a bar graph
- Added `@batt_remain_short` option to shorten remaining time display
- Added WSL (Windows Subsystem for Linux) support
- Added OpenBSD `apm` support
- Added `battery_enabled.tmux` script for conditionally showing battery
- Fixed battery graph display
- Removed deprecated `#{battery_status_bg}` and `#{battery_status_fg}` format strings
- Changed preferred order of utility applications to: pmset → acpi → upower → termux-battery-status due to CPU usage issues with upower

### v1.2.0, 2016-09-24
- show output for `#{battery_remain}` interpolation only if the battery is
  discharging
- prevent displaying "(No" for `#{battery_remain}` interpolation (when battery
  status is "No estimate"
- display all batteries that upower knows about (@JanAhrens)
- acpi battery status (@cpb)
- fix issue with status-right and status-left whitespace being cut out
- fix issue with the `pmset -g batt` command output for macOS Sierra and further 

### v1.1.0, 2015-03-14
- change the default icon for "attached" battery state from :snail: to :warning:
- add support for OS X "attached" battery state (@m1foley)
- add `#{battery_remain}` feature (@asethwright)

### v1.0.0, 2014-08-31
- update readme to reflect github organization change
- bring in linux support
- small refactoring
- rename plugin to tmux-battery
- add contributors to the readme

### v0.0.2, 2014-06-03
- switch to tab indentation
- do not automatically prepend battery status
- change format interpolation strings to more Tmux-idiomatic
  `#{battery_percentage}` and `#{battery_icon}`
- refactoring for simplicity
- support interpolation in `status-left` option too
- README update

### v0.0.1, 2014-06-03
- tag version 0.0.1
