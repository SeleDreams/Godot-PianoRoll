extends MidiEditorState


func enter(msg := {}):
	midi_editor_view.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func input(event):
	_parent.update_input(Input.CURSOR_ARROW,self)
