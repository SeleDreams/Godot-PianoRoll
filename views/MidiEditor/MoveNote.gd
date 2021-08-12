extends MidiEditorState


var offset : int
var note : Note
var previous_state : String

func enter(msg := {}):
	offset = msg["offset"]
	note = msg["note"]
	previous_state = msg["state"]

func input(event):
	if Input.is_action_just_released("select"):
		_state_machine.transition_to_state(previous_state)
	if event is InputEventMouseMotion:
		var mouse_pos = midi_editor.mouse_pos_to_grid_pos()
		note.pos = max(0,midi_editor.ticks_to_steps(mouse_pos.x - offset))
		note.note = clamp(mouse_pos.y,0,Globals.octave_keys.KEY_COUNT * Globals.octaves.OCTAVE_COUNT)
