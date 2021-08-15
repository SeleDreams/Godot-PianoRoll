extends MidiEditorState
class_name ResizeNote

var note_side : int
var previous_state : String
var original_pos :={}

func enter(msg := {}):
	note_side = msg["side"]
	previous_state = msg["state"]
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_HSIZE)
	for note in midi_editor_view.selected_notes:
		var mouse_pos = midi_editor.mouse_pos_to_grid_pos()
		original_pos[note] = Vector3(note.pos,note.length,mouse_pos.x)

func exit():
	previous_state = ""
	note_side = -1

# ngl, the current code is awful
# todo : improve readability and stability
func input(event):
	if Input.is_action_just_released("select"):
		_state_machine.transition_to_state(previous_state)
	var pos = midi_editor.mouse_pos_to_grid_pos()
	if event is InputEventMouseMotion:
		for drawn_note in midi_editor_view.selected_notes:
			if note_side == Globals.side.RIGHT:
				var offset = midi_editor.ticks_to_length_steps(original_pos[drawn_note].z - (original_pos[drawn_note].x + original_pos[drawn_note].y))
				drawn_note.length = max(midi_editor.get_length_step(),midi_editor.ticks_to_length_steps(pos.x)  - (drawn_note.pos + offset))
			elif note_side == Globals.side.LEFT:
				var offset = midi_editor.ticks_to_length_steps(original_pos[drawn_note].z - (original_pos[drawn_note].x)) - midi_editor.get_length_step()
				var original_pos = drawn_note.pos
				var original_length = drawn_note.length
				var new_pos = midi_editor.ticks_to_length_steps(pos.x) - offset
				drawn_note.pos = max(0,min(original_pos + original_length - midi_editor.get_length_step(),new_pos))
				drawn_note.length += original_pos - drawn_note.pos
				
