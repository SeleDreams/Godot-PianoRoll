extends Resource
class_name MidiClip

export var timesig_numerator : float = 4
export var timesig_denominator : float = 4
export var quantization_numerator : float = 1
export var quantization_denominator : float = 16
export var bpm : float = 120
export var beats : int

func get_quantization() -> float:
	return timesig_numerator / (quantization_numerator / quantization_denominator)

func _init(p_timesig_numerator = 4,p_timesig_denominator = 4,p_quantization_numerator = 1, p_quantization_denominator = 16, p_bpm = 120, p_beats = 1):
	timesig_numerator = p_timesig_numerator
	timesig_denominator = p_timesig_denominator
	quantization_numerator = p_quantization_numerator
	quantization_denominator = p_quantization_denominator
	bpm = p_bpm
	beats = p_beats
