extends Node

const default_ticks_per_bar : int = 960
var ticks_per_bar : int = default_ticks_per_bar

const default_steps_per_bar : int =  16
var steps_per_bar = default_steps_per_bar

const default_beats_per_bar : int = default_ticks_per_bar / default_steps_per_bar
var beats_per_bar : int = default_beats_per_bar

enum octaves {
	OCTAVE_M1,
	OCTAVE_0,
	OCTAVE_1,
	OCTAVE_2,
	OCTAVE_3,
	OCTAVE_4,
	OCTAVE_5,
	OCTAVE_6,
	OCTAVE_7,
	OCTAVE_8,
	OCTAVE_COUNT
}

enum octave_keys{
	KEY_C = 0,
	KEY_CSHARP = 1,KEY_DFLAT = 1,
	KEY_D = 2,
	KEY_DSHARP = 3, KEY_EFLAT = 3,
	KEY_E = 4, KEY_FFLAT = 4,
	KEY_F = 5,
	KEY_FSHARP = 6, KEY_GFLAT = 6,
	KEY_G = 7,
	KEY_GSHARP = 8, KEY_AFLAT = 8,
	KEY_A = 9,
	KEY_ASHARP = 10, KEY_BFLAT = 10,
	KEY_B = 11
	KEY_COUNT
}

enum side{
	LEFT,
	RIGHT
}
