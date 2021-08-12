extends MidiEditorState
class_name ResizeNote

var note_side : int
var previous_state : String
var selected_note : Note

func enter(msg := {}):
	note_side = msg["side"]
	previous_state = msg["state"]
	selected_note = msg["note"]
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_HSIZE)

func exit():
	previous_state = ""
	note_side = -1
	selected_note = null

func input(event):
	if Input.is_action_just_released("select"):
		_state_machine.transition_to_state(previous_state)
	var pos = midi_editor.mouse_pos_to_grid_pos()
	if event is InputEventMouseMotion:
		var drawn_note = selected_note
		drawn_note.length = max(midi_editor.get_length_step(),midi_editor.ticks_to_length_steps(pos.x) - drawn_note.pos)
