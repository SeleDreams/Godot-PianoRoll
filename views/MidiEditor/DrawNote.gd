extends MidiEditorState
class_name DrawNote

var hovered_note : Note

func enter(msg := {}):
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_CROSS)

func input(event):
	_parent.update_input(Input.CURSOR_CROSS,self)
	if not midi_editor_view.hovered:
		return
	var pos : Vector2 = midi_editor.mouse_pos_to_grid_pos()
	if Input.is_action_just_pressed("select") and _parent.hovering_note == null:
		midi_editor_view.clear_selection()
		var new_note = Note.new()
		new_note.note = pos.y
		new_note.pos = midi_editor.ticks_to_steps(pos.x)
		new_note.length = midi_editor.get_length_step()
		midi_editor.midi_clip.add_note(new_note)
		midi_editor_view.clear_selection()
		midi_editor_view.select_note(new_note)
		_state_machine.transition_to_state("ResizeNote",{
			"side" : Globals.side.RIGHT,
			"state": get_path()})
