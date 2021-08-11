extends State

var midi_editor : MidiEditor
var midi_editor_view : MidiEditorView

var drawn_note_id : int
var clicked : bool
var hovered_note : Note

func enter(msg := {}):
	midi_editor = _state_machine._target_node
	midi_editor_view = midi_editor.midi_editor_view


func input(event):
	if not midi_editor_view.hovered:
		return
	var clip = midi_editor.midi_clip
	var pos = midi_editor.mouse_pos_to_grid_pos()
	var notes = clip.notes
	if Input.is_action_just_pressed("select") and hovered_note == null and not clicked:
		clicked = true
		var new_note = Note.new()
		new_note.note = pos.y
		new_note.pos = pos.x
		new_note.length = midi_editor.get_step()
		clip.notes[drawn_note_id] = new_note
	if Input.is_action_just_released("select") and clicked :
		clicked = false
		drawn_note_id += 1
	if event is InputEventMouseMotion:
		var note_hovered : Note
		for note_id in notes:
			var note = notes[note_id]
			if pos.x >= note.pos and pos.x <= note.pos + note.length and stepify((pos.y / midi_editor_view.vertical_scale),1)  == note.note:
				note_hovered = note
		hovered_note = note_hovered
		if clicked:
				var drawn_note = clip.notes[drawn_note_id]
				drawn_note.length = max(Globals.default_ticks_per_bar / clip.quantization_denominator,pos.x - clip.notes[drawn_note_id].pos)
