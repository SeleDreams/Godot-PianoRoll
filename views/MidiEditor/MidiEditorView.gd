tool
extends Control
class_name MidiEditorView

export var bar_color : Color
export var beat_color : Color
export var quantization_color : Color
export var octave_color : Color
export var note_color : Color
export var background_color : Color
export var highlight_color : Color

var vertical_offset : int
var horizontal_offset : int
var vertical_scale : float
var horizontal_scale : float
var total_horizontal_size : float
var total_vertical_size : float
var midi_clip : MidiClip
var bar_count : int

func clear_background():
	draw_rect(Rect2(Vector2.ZERO,Vector2(rect_size.x,rect_size.y)),background_color)

func draw_highlighted_part(clip : MidiClip):
	var bpm_factor = 100 as float / clip.bpm
	var right_side = min(rect_size.x,(horizontal_scale * clip.beats / clip.timesig_numerator / clip.timesig_denominator * bpm_factor) - horizontal_offset)
	if right_side > 0:
		draw_rect(Rect2(Vector2.ZERO,Vector2(right_side,rect_size.y)),highlight_color)

func draw_beats(clip : MidiClip):
	var bpm_factor = 100 as float / clip.bpm
	for i in range(1,bar_count * clip.timesig_numerator + 1):
			var beat_pos = Vector2((horizontal_scale * i / clip.timesig_numerator / clip.timesig_denominator * bpm_factor) - horizontal_offset,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,rect_size.y),beat_color,2.0)

func draw_quantization(clip : MidiClip):
	var bpm_factor = 100 as float / clip.bpm
	var quantization = clip.get_quantization()
	print(quantization)
	for i in range(1,(bar_count / clip.timesig_numerator) * quantization ):
			var beat_pos = Vector2((horizontal_scale * i / quantization * bpm_factor) - horizontal_offset,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,rect_size.y),quantization_color,1.0)

func draw_bars(clip : MidiClip):
	var bpm_factor = 100 as float / clip.bpm
	for i in range(0,bar_count + 1):
		var bar_pos = Vector2((horizontal_scale * i / clip.timesig_denominator * bpm_factor) - horizontal_offset ,0)
		if bar_pos.x < rect_size.x and bar_pos.x > 0:
			draw_line(bar_pos,bar_pos + Vector2(0,rect_size.y),bar_color,3.0)

func draw_octaves(number_octaves):
	for i in range(1,number_octaves * 12):
		var octave_pos = Vector2(0,vertical_scale * i) - Vector2(0,vertical_offset)
		var line_size : int = 1 if i % 12 != 0 else 2
		if octave_pos.y < rect_size.y and octave_pos.y > 0:
			draw_line(octave_pos,octave_pos + Vector2(rect_size.x,0),note_color,line_size)

func draw_elements(clip : MidiClip):
		clear_background()
		draw_highlighted_part(clip)
		draw_octaves(8)
		draw_quantization(clip)
		draw_beats(clip)
		draw_bars(clip)

func _draw():
	if (midi_clip != null):
		draw_elements(midi_clip)
