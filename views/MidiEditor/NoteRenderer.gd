extends Control
class_name NoteView

var clip : MidiClip
var offset : Vector2
var horizontal_scale : float
var vertical_scale : float
var done : bool
var bpm_factor
var note_id : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner,"ready")
	bpm_factor = 100 as float / clip.bpm
	connect("mouse_entered",self,"_mouse_entered")
	connect("mouse_exited",self,"_mouse_exited")

func _mouse_entered():
	set_default_cursor_shape(CURSOR_POINTING_HAND)
	
func _mouse_exited():
	set_default_cursor_shape(CURSOR_ARROW)

func _input(event : InputEvent):
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed == false:
				var pos = get_local_mouse_position() + offset
				pos.y = (Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT * vertical_scale) - pos.y
				var new_note = Note.new()
				new_note.note = (pos.y / vertical_scale) as int + 1
				new_note.length = Globals.default_ticks_per_bar / clip.timesig_numerator
			#	print("bar is ",(pos.x as int / (horizontal_scale * bpm_factor)) / Globals.default_ticks_per_bar )
				var note_position_ticks : int = ((pos.x as int / (horizontal_scale * bpm_factor)) ) 
				var bar_count = (note_position_ticks / Globals.default_ticks_per_bar)
				var quantization = clip.get_quantization()
				var rest = note_position_ticks as int % (Globals.default_ticks_per_bar / quantization * clip.timesig_numerator) as int
				var final_pos = note_position_ticks - rest
				print(final_pos)
				new_note.pos = final_pos
				clip.notes[note_id] = new_note
				note_id += 1
		

func _draw():
	for note_id in clip.notes:
		var note : Note = clip.notes[note_id]
		var note_pos : Vector2 = Vector2(note.pos * horizontal_scale * bpm_factor, ((Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT) - note.note) * vertical_scale) - offset
		var note_length = (note.length * horizontal_scale * bpm_factor)
		if note_pos.x + note_length > 0 and note_pos.x < rect_size.x and note_pos.y + vertical_scale > 0 and note_pos.y < rect_size.y:
			draw_rect(Rect2(note_pos,Vector2(note_length,vertical_scale)),Color.green)
