tool
extends Control
class_name MidiDrawArea

export var timesig_numerator : int = 4
export var timesig_denominator : int = 4

export var quantization_numerator : int = 1
export var quantization_denominator : int = 16

export var bpm : int = 120
export var horizontal_scale : float = 50
export var vertical_scale : float = 20

export var bars : int
export var zoom_steps : float = 0.2
export var max_h_zoom : float = 500
export var min_h_zoom : float = 150
export var max_v_zoom : float = 200
export var min_v_zoom : float = 100
export var octave_notes : int = 12
export var number_octaves : int = 8

onready var timesig : float = timesig_numerator as float / timesig_denominator
onready var hzoom : float = 1
onready var vzoom : float = 1

var vertical_offset : int
var horizontal_offset : int
var draw_width : int
var draw_height : int

var space_between_bars : float
var space_between_notes : float

var total_horizontal_size : float
var total_vertical_size : float

export var bar_color : Color
export var beat_color : Color
export var quantization_color : Color
export var octave_color : Color
export var note_color : Color
export var background_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	update_zoom()

func clear_background():
	draw_rect(Rect2(Vector2.ZERO,Vector2(draw_width,draw_height)),background_color)

func draw_beats():
	var bpm_factor = 100 as float / bpm
	for i in range(1,bars * timesig_numerator):
			var beat_pos = Vector2((space_between_bars * i / timesig_numerator / timesig_denominator * bpm_factor) - horizontal_offset,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,draw_height),beat_color,2.0)

func draw_quantization():
	var bpm_factor = 100 as float / bpm
	for i in range(1,bars * quantization_denominator):
			var beat_pos = Vector2((space_between_bars * i / quantization_denominator / timesig_denominator * bpm_factor) - horizontal_offset,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,draw_height),quantization_color,1.0)

func draw_bars():
	var bpm_factor = 100 as float / bpm
	for i in range(0,bars + 1):
		var bar_pos = Vector2((space_between_bars * i / timesig_denominator * bpm_factor) - horizontal_offset ,0)
		if bar_pos.x < rect_size.x and bar_pos.x > 0:
			draw_line( bar_pos,bar_pos + Vector2(0,draw_height),bar_color,3.0)

func draw_octaves():
	for i in range(1,number_octaves * octave_notes):
		var octave_pos = Vector2(0,space_between_notes * i) - Vector2(0,vertical_offset)
		var line_size : int = 1 if i % octave_notes != 0 else 2
		if octave_pos.y < rect_size.y and octave_pos.y > 0:
			draw_line(octave_pos,octave_pos + Vector2(draw_width,0),note_color,line_size)
#		for j in range(0,octave_notes):
#			var note_pos = (octave_pos + Vector2(0,j * space_between_notes)) + Vector2(0,vertical_offset)
#			draw_line(note_pos,note_pos + Vector2(0,draw_width),Color.white)

func update_zoom():
	hzoom = clamp(hzoom,min_h_zoom,max_h_zoom)
	vzoom = clamp(vzoom,min_v_zoom,max_v_zoom)
	space_between_bars = horizontal_scale * hzoom
	space_between_notes = vertical_scale * vzoom
	var bpm_factor = 100 as float / bpm
	total_horizontal_size = (space_between_bars * bars / timesig_denominator * bpm_factor) + 20
	total_vertical_size = space_between_notes * number_octaves * octave_notes 
	update()

func _draw():
	clear_background()
	draw_octaves()
	draw_quantization()
	draw_beats()
	draw_bars()
