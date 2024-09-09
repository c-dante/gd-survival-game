extends Node

## Formats a floating point as a % with optional precision
## percent - A percentage, e.g., 0.25 for 25%
## precision - Arg for snapped, the minimum step. So, 1 is whole numbers
func format_percent(percent: float, precision: float = 1) -> String:
	return "%d%%" % snapped(percent * 100, precision)

## Formats seconds in #h #m #s, with hours in the full whole number remainder
## time_seconds - The duration in seconds
func format_elapsed_time(time_seconds: float) -> String:
	var seconds = time_seconds
	var hours = snapped(seconds / 3600.0, 0)
	seconds -= hours * 3600
	var mins = snapped(seconds / 60.0, 0)
	seconds -= mins * 60
	return "%dh %dm %ds" % [hours, mins, seconds]

func format_number_grouped(value: float):
	var as_str = "%d" % floor(value)
	var l = as_str.length()
	for i in range(l - 3, 0, -3):
		as_str = as_str.insert(i, ",")
	return as_str
