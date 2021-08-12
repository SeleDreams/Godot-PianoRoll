extends Resource
class_name MidiClip

export var timesig_numerator : float = 4
export var timesig_denominator : float = 4
export var bpm : float = 120
export var beats : int
var notes : Array

func _init(p_timesig_numerator = 4,p_timesig_denominator = 4,p_quantization_numerator = 1, p_quantization_denominator = 16, p_bpm = 120, p_beats = 1):
	timesig_numerator = p_timesig_numerator
	timesig_denominator = p_timesig_denominator
	bpm = p_bpm
	beats = p_beats
