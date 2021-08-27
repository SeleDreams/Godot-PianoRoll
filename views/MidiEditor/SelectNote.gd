extends MidiEditorState

var rect_active : bool

func enter(msg := {}):
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_ARROW)

func update_selection_rect():
	if Input.is_action_just_pressed("select") and _parent.hovering_note == null:
		rect_active = true
		midi_editor_view.selection_rect.position = midi_editor_view.get_local_mouse_position()
	elif Input.is_action_pressed("select"):
		midi_editor_view.selection_rect.size = midi_editor_view.get_local_mouse_position() - midi_editor_view.selection_rect.position
	else:
		midi_editor_view.selection_rect = Rect2()
		rect_active = false

func input(event):
	_parent.update_input(Input.CURSOR_ARROW,self)
	var hover : HoverNote = _parent
	update_selection_rect()
	if rect_active:
		var grid_selection_begin : Vector2 = midi_editor.pos_to_grid_pos(midi_editor_view.selection_rect.position + midi_editor_view.offset)
		var grid_selection_end : Vector2 = midi_editor.pos_to_grid_pos(midi_editor_view.selection_rect.size + grid_selection_begin)
		for note in midi_editor_view.selected_notes:
			var between_x = note.pos + note.length >= grid_selection_begin.x and note.pos <= grid_selection_end.x
			var between_y = note.note >= grid_selection_begin.y and note.note <= grid_selection_end.y
			if between_x and between_y:
				midi_editor_view.select_note(note)
			else:
				midi_editor_view.unselect_note(note)

	if hover.hovering_note == null or rect_active:
		return
	if Input.is_action_just_released("select") and not Input.is_action_pressed("control"):
		midi_editor_view.clear_selection()
	if hover.hovering_note.selected == false:
		midi_editor_view.select_note(hover.hovering_note)
	elif Input.is_action_pressed("control"):
		midi_editor_view.unselect_note(hover.hovering_note)
