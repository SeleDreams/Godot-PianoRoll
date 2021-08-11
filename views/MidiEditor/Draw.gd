extends State

var midi_editor : MidiEditor
var midi_editor_view : MidiEditorView
var hovered_note : Note

func enter(msg := {}):
	midi_editor = _state_machine._target_node
	midi_editor_view = midi_editor.midi_editor_view


func input(event):
	if not midi_editor_view.hovered:
		return
	var clip : MidiClip = midi_editor.midi_clip
	var pos : Vector2 = midi_editor.mouse_pos_to_grid_pos()
	var notes : Array = clip.notes
	if Input.is_action_just_pressed("select") and hovered_note == null:
		var new_note = Note.new()
		new_note.note = pos.y
		new_note.pos = pos.x
		new_note.length = midi_editor.get_step()
		notes.append(new_note)
		var msg : Dictionary = {"note" : new_note,"state" : name,"side" : Globals.side.RIGHT}
		_state_machine.transition_to_state("ResizeNote",msg)
	
