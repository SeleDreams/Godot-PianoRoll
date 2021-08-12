extends MidiEditorState

var previous_state : String
var offsets := {}
var offset_with_first_note := {}
func enter(msg := {}):
	previous_state = msg["state"]
	var lowest_index = -1
	for note in midi_editor_view.selected_notes:
		var mouse_pos = midi_editor.mouse_pos_to_grid_pos()
		offsets[note] = Vector2(midi_editor.ticks_to_steps(mouse_pos.x) - note.pos,mouse_pos.y - note.note)
		if note.selected_index < lowest_index or lowest_index == -1:
			lowest_index = note.selected_index
	for note in midi_editor_view.selected_notes:
		offset_with_first_note[note] = note.pos - midi_editor_view.selected_notes[lowest_index].pos

func exit():
	offsets.clear()

func input(event):
	if Input.is_action_just_released("select"):
		_state_machine.transition_to_state(previous_state)
	if event is InputEventMouseMotion:
		var mouse_pos = midi_editor.mouse_pos_to_grid_pos()
		for note in midi_editor_view.selected_notes:
			note.pos = max(offset_with_first_note[note],midi_editor.ticks_to_steps(mouse_pos.x) - offsets[note].x)
			note.note = clamp(mouse_pos.y - offsets[note].y,0,Globals.octave_keys.KEY_COUNT * Globals.octaves.OCTAVE_COUNT)
