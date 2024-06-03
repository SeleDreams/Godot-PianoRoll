extends Resource
class_name MidiClip

export var timesig_numerator : float = 4
export var timesig_denominator : float = 4
export var bpm : float = 120
export var beats : int
export var notes : Array

signal removed_note
signal added_note
signal sorted_notes


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

func serialize() -> Dictionary:
	var output : Dictionary = Dictionary()
	output["timesig_numerator"] = timesig_numerator
	output["timesig_denominator"] = timesig_denominator
	output["bpm"] = bpm
	output["beats"] = beats
	var note_array := Array()
	for note in notes:
		note_array.append(note.serialize())
	output["notes"] = note_array
	return output

func deserialize(dic : Dictionary):
	timesig_numerator = dic["timesig_numerator"]
	timesig_denominator = dic["timesig_denominator"]
	bpm = dic["bpm"]
	beats = dic["beats"]
	var note_array : Array = dic["notes"]
	for i in range(0,note_array.size()):
		var note : Dictionary = note_array[i]
		var added_note = Note.new()
		added_note.deserialize(note)
		add_note(added_note)
