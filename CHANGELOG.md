# Changelog

### master
- Fixed `#{battery_graph}` to actually display graph (@rux616)
- High-granularity icons and colors added. (@rux616)
- Changed preferred order of utility applications to be `pmset` -> `acpi` -> `upower` -> `termux-battery-status` due to CPU usage issues with `upower` (2019-03-05) (@rux616)
- Added `#{battery_status_bg}` feature (@RyanFrantz) 
- Added multibattery output support for `upower` (@futuro)
- Added Chromebook support (@forkjoseph)
- Added battery graph, simplify interpolation (@levens)

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
