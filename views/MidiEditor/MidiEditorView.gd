extends MusicalGrid
class_name MidiEditorView


export var octave_color : Color
export var note_color : Color
export var selected_note_color : Color
export var highlight_color : Color
export var white_key_shade : Color
export var key_color : Color
export var selection_color : Color
var selected_notes : Array
var selection_rect : Rect2
export var note_font : Font

func draw_highlighted_part():
	var right_side = min(rect_size.x,(horizontal_scale * midi_editor.midi_clip.beats / midi_editor.midi_clip.timesig_numerator / midi_editor.midi_clip.timesig_denominator * midi_editor.bpm_factor) - offset.x)
	if right_side > 0:
		draw_rect(Rect2(Vector2.ZERO,Vector2(right_side,rect_size.y)),highlight_color)


func draw_octaves():
	for i in range(1,Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT):
		var octave_pos = Vector2(0,vertical_scale * (Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT - i)) - Vector2(0,offset.y)
		var line_size : int = 1 if (i-1) % Globals.octave_keys.KEY_COUNT != 0 else 2
		var line_color : Color = key_color if (i-1) % 12 != 0 else octave_color
		if octave_pos.y - vertical_scale < rect_size.y and octave_pos.y + vertical_scale > 0:
			var note = ((i-1) % 12)
			var keys = Globals.octave_keys
			if (note == keys.KEY_A or note == keys.KEY_B or note == keys.KEY_C or note == keys.KEY_D or note == keys.KEY_E or note == keys.KEY_F or note == keys.KEY_G):
				draw_rect(Rect2(octave_pos - Vector2(0,vertical_scale),Vector2(rect_size.x,vertical_scale)),white_key_shade)
			draw_line(octave_pos,octave_pos + Vector2(rect_size.x,0),line_color,line_size)

func draw_notes():
	var clip = midi_editor.midi_clip
	for note in clip.notes:
		var note_pos : Vector2 = midi_editor.grid_pos_to_local_pos(Vector2(note.pos,note.note))
		var note_length =  midi_editor.ticks_to_width(note.length)
		if note_pos.x + note_length > 0 and note_pos.x < rect_size.x and note_pos.y + vertical_scale > 0 and note_pos.y < rect_size.y:
			if note.selected:
				draw_rect(Rect2(note_pos,Vector2(note_length,vertical_scale)),selected_note_color)
			else:
				draw_rect(Rect2(note_pos,Vector2(note_length,vertical_scale)),note_color)
			var string_size = note_font.get_string_size(note.phoneme)
			draw_string(note_font,note_pos + Vector2(5,vertical_scale / 2 + string_size.y  / 4),note.phoneme)

func draw_selection():
	draw_rect(selection_rect,selection_color)

func is_hovering_note(position : Vector2,note : Note):
	var hovering_horizontal : bool = position.x >= note.pos and position.x <= note.pos + note.length
	var hovering_vertical : bool = position.y as int == note.note
	return hovering_horizontal and hovering_vertical


func update_offsets(x,y):
	offset = Vector2(x,y)


func sort_selected_notes():
	selected_notes.sort_custom(midi_editor.midi_clip,"sortNotesByPos")
	selected_notes.sort()
	for i in range(0,selected_notes.size()):
		selected_notes[i].selected_index = i

func select_note(note):
	print("select")
	assert(not note.selected)
	note.selected = true
	selected_notes.append(note)
	sort_selected_notes()

func unselect_note(note):
	print("unselect")
	assert(note.selected)
	note.selected = false
	selected_notes.remove(note.selected_index)
	sort_selected_notes()
	note.selected_index = -1

func clear_selection():
	print("clear")
	print(selected_notes)
	for note in selected_notes:
		if note != null:
			note.selected = false
			note.selected_index = -1
	selected_notes.clear()
	print(selected_notes)
	print("clear done")

func delete_selection():
	for note in selected_notes:
		midi_editor.midi_clip.remove_note(note)
	clear_selection()

func _draw():
	clear_background()
	draw_highlighted_part()
	draw_octaves()
	draw_grid()
	draw_notes()
	draw_selection()
	draw_timeline()

func update_scale(scale : Vector2):
	horizontal_scale = scale.x
	vertical_scale = scale.y

