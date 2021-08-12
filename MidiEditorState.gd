extends State
class_name MidiEditorState

var midi_editor
var midi_editor_view

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner,"ready")
	._ready()
	midi_editor = _state_machine._target_node
	midi_editor_view = midi_editor.midi_editor_view


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
