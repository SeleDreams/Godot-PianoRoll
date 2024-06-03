extends Node
class_name MusicalTime

var ticks

func get_bar() -> int:
	return ticks / Globals.ticks_per_bar

func get_beat() -> int:
	return get_bar() / Globals.beats_per_bar
