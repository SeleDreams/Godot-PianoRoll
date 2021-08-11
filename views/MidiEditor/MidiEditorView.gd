tool
extends MusicalGrid
class_name MidiEditorView

export var octave_color : Color
export var note_color : Color
export var highlight_color : Color
export var white_key_shade : Color
onready var note_view : NoteView = $NoteView

func draw_highlighted_part():
	var bpm_factor = 100 as float / clip.bpm
	var right_side = min(rect_size.x,(horizontal_scale * clip.beats / clip.timesig_numerator / clip.timesig_denominator * bpm_factor) - offset.x)
	if right_side > 0:
		draw_rect(Rect2(Vector2.ZERO,Vector2(right_side,rect_size.y)),highlight_color)


func draw_octaves():
	for i in range(1,Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT):
		var octave_pos = Vector2(0,vertical_scale * (Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT - i)) - Vector2(0,offset.y)
		var line_size : int = 1 if (i-1) % Globals.octave_keys.KEY_COUNT != 0 else 2
		var line_color : Color = note_color if (i-1) % 12 != 0 else octave_color
		if octave_pos.y - vertical_scale < rect_size.y and octave_pos.y + vertical_scale > 0:
			var note = ((i-1) % 12)
			var keys = Globals.octave_keys
			if (note == keys.KEY_A or note == keys.KEY_B or note == keys.KEY_C or note == keys.KEY_D or note == keys.KEY_E or note == keys.KEY_F or note == keys.KEY_G):
				draw_rect(Rect2(octave_pos - Vector2(0,vertical_scale),Vector2(rect_size.x,vertical_scale)),white_key_shade)
			draw_line(octave_pos,octave_pos + Vector2(rect_size.x,0),line_color,line_size)

func update_offsets(x,y):
	offset = Vector2(x,y)
	note_view.offset = offset

func update_midiclip(new_clip : MidiClip):
	clip = new_clip
	note_view.clip = clip

func _draw():
	clear_background()
	draw_highlighted_part()
	draw_octaves()
	draw_grid()
	draw_timeline()
	note_view.update()

func update_scale(scale : Vector2):
	horizontal_scale = scale.x
	vertical_scale = scale.y
	note_view.horizontal_scale = scale.x
	note_view.vertical_scale = scale.y
