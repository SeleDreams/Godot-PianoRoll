extends MidiEditorState
class_name HoverNote

export var deadzone_note_resize : int
var hovering_note : Note
var in_resize_area : bool
var mouse_position : Vector2

func update_current_note() -> bool:
	for note in midi_editor.midi_clip.notes:
			if midi_editor_view.is_hovering_note(mouse_position,note):
				hovering_note = note
				return true
	hovering_note = null
	return false

func update_resize():
	var note = hovering_note
	var pos = mouse_position
	var right_side : bool = pos.x > note.pos + note.length - clamp(note.length / deadzone_note_resize,deadzone_note_resize / 4,deadzone_note_resize)
	if right_side:
		midi_editor_view.set_default_cursor_shape(Input.CURSOR_HSIZE)
		in_resize_area = true
	else:
		midi_editor_view.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		in_resize_area = false


func update_input(cursor : int,state : MidiEditorState):
	mouse_position = midi_editor.mouse_pos_to_grid_pos()
	if not update_current_note():
		midi_editor_view.set_default_cursor_shape(cursor)
	else:
		update_resize()
		if Input.is_action_pressed("select"):
			if Input.is_action_just_pressed("select"):
				if not Input.is_action_pressed("control") and (hovering_note == null or hovering_note.selected == false):
					midi_editor_view.clear_selection()
				if hovering_note != null:
					if Input.is_action_pressed("control") and hovering_note.selected:
						midi_editor_view.unselect_note(hovering_note)
					elif not hovering_note.selected:
						midi_editor_view.select_note(hovering_note)
			if in_resize_area and hovering_note.selected:
				_state_machine.transition_to_state("ResizeNote",{
					"side":Globals.side.RIGHT,
					"state":state.get_path()})
			else:
				_state_machine.transition_to_state("MoveNote",{
					"state":state.get_path()})
