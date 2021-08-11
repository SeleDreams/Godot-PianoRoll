extends State

var midi_editor : MidiEditor
var midi_editor_view : MidiEditorView
var note_side : int
var previous_state : String
var selected_note : Note

func enter(msg := {}):
	midi_editor = _state_machine._target_node
	midi_editor_view = midi_editor.midi_editor_view
	note_side = msg["side"]
	previous_state = msg["state"]
	selected_note = msg["note"]

func input(event):
	var pos = midi_editor.mouse_pos_to_grid_pos()
	if event is InputEventMouseMotion:
		var drawn_note = selected_note
		drawn_note.length = max(Globals.default_ticks_per_bar / midi_editor.midi_clip.quantization_denominator,pos.x - drawn_note.pos)
	if Input.is_action_just_released("select"):
		_state_machine.transition_to_state(previous_state)
