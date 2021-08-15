extends MidiEditorState


func enter(msg := {}):
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_ARROW)



func input(event):
	_parent.update_input(Input.CURSOR_ARROW,self)
	var hover : HoverNote = _parent
	if not Input.is_action_just_released("select") or  hover.hovering_note == null:
		return
	if not Input.is_action_pressed("control"):
		midi_editor_view.clear_selection()
	if hover.hovering_note.selected == false:
		midi_editor_view.select_note(hover.hovering_notes)
	elif Input.is_action_pressed("control"):
		midi_editor_view.unselect_note(hover.hovering_note)
		
