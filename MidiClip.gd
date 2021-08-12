extends Resource
class_name MidiClip

export var timesig_numerator : float = 4
export var timesig_denominator : float = 4
export var bpm : float = 120
export var beats : int
var notes : Array

signal removed_note
signal added_note
signal sorted_notes

func _init(p_timesig_numerator = 4,p_timesig_denominator = 4,p_quantization_numerator = 1, p_quantization_denominator = 16, p_bpm = 120, p_beats = 1):
	timesig_numerator = p_timesig_numerator
	timesig_denominator = p_timesig_denominator
	bpm = p_bpm
	beats = p_beats

func sort_notes():
	notes.sort_custom(self,"sortNotesByPos")
	for i in range(0,notes.size()):
		notes[i].index = i
	emit_signal("sorted_notes")

func add_note(note):
	notes.append(note)
	sort_notes()
	emit_signal("added_note",note)
		
func remove_note(note):
	assert(note.index > -1)
	notes.remove(note.index)
	sort_notes()
	note.selected_index = -1
	emit_signal("removed_note",note)

func sortNotesByPos(a, b):
	return a.pos < b.pos
