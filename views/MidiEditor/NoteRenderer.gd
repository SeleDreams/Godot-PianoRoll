extends Control
class_name NoteView

var clip : MidiClip
var offset : Vector2
var horizontal_scale : float
var vertical_scale : float
var done : bool
var bpm_factor
var note_id : int = 1
var clicked : bool
var hovered : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner,"ready")
	bpm_factor = 100 as float / clip.bpm
	connect("mouse_entered",self,"_mouse_entered")
	connect("mouse_exited",self,"_mouse_exited")

func _mouse_entered():
	hovered = true
	
func _mouse_exited():
	hovered = false

func _input(event : InputEvent):
	if not hovered:
		return
	var pos = get_local_mouse_position() + offset
	pos.y = (Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT * vertical_scale) - pos.y
	var note_position_ticks : int = ((pos.x as int / (horizontal_scale * bpm_factor)) ) 
	var bar_count = (note_position_ticks / Globals.default_ticks_per_bar)
	var ticks = Globals.default_ticks_per_bar / clip.timesig_numerator / clip.quantization_denominator / (clip.quantization_numerator / clip.timesig_denominator)
	print(ticks)
	var rest = note_position_ticks as int % ticks as int
	var final_pos = note_position_ticks - rest
	pos.x = final_pos
	if Input.is_action_just_pressed("select"):
		clicked = true
		var new_note = Note.new()
		new_note.note = (pos.y / vertical_scale) as int + 1
		new_note.pos = pos.x
		new_note.length = ticks
		clip.notes[note_id] = new_note
	if Input.is_action_just_released("select"):
		clicked = false
		note_id += 1
	if event is InputEventMouseMotion and clicked:
				clip.notes[note_id].length = max(Globals.default_ticks_per_bar / clip.quantization_denominator,pos.x - clip.notes[note_id].pos)

func _draw():
	for note_id in clip.notes:
		var note : Note = clip.notes[note_id]
		var note_pos : Vector2 = Vector2(note.pos * horizontal_scale * bpm_factor, ((Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT) - note.note) * vertical_scale) - offset
		var note_length = (note.length * horizontal_scale * bpm_factor)
		if note_pos.x + note_length > 0 and note_pos.x < rect_size.x and note_pos.y + vertical_scale > 0 and note_pos.y < rect_size.y:
			draw_rect(Rect2(note_pos,Vector2(note_length,vertical_scale)),Color.green)
