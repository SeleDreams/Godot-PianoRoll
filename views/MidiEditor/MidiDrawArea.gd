tool
extends Control
class_name MidiDrawArea

export var timesig_numerator : int = 4
export var timesig_denominator : int = 4
export var bpm : int = 120
export var horizontal_scale : float = 50
export var bars : int
export var zoom_steps : float = 0.2
export var max_zoom : float = 500
export var min_zoom : float = 150

onready var timesig : float = timesig_numerator as float / timesig_denominator
onready var hzoom : float = 1
onready var vzoom : float = 1

var vertical_offset : int
var horizontal_offset : int
var draw_width : int
var draw_height : int
var space_between_bars : float
var actual_space_of_bar : float
var total_size : float

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_min_size.y = draw_height
	update_zoom()

func clear_background():
	draw_rect(Rect2(Vector2(-horizontal_offset,0) + Vector2(horizontal_offset,vertical_offset),Vector2(draw_width,draw_height)),Color(40 as float / 255,40 as float / 255,40 as float / 255,1))

func draw_beats():
	var bpm_factor = 100 as float / bpm
	actual_space_of_bar = space_between_bars + (timesig_denominator * bpm_factor)
	for i in range(1,bars * timesig_numerator):
			var beat_pos = Vector2(space_between_bars * i / timesig_numerator / timesig_denominator  * bpm_factor  ,0)
			if beat_pos.x < rect_size.x + horizontal_offset and beat_pos.x > horizontal_offset:
				draw_line(Vector2(-horizontal_offset,0) + beat_pos,Vector2(-horizontal_offset,0) + beat_pos + Vector2(0,draw_height),Color.gray)

func draw_bars():
	var bpm_factor = 100 as float / bpm
	for i in range(1,bars + 1):
		var bar_pos = Vector2(space_between_bars * i / timesig_denominator * bpm_factor ,0)
		if bar_pos.x < rect_size.x + horizontal_offset and bar_pos.x > horizontal_offset:
			draw_line(Vector2(-horizontal_offset,0) + bar_pos,Vector2(-horizontal_offset,0) +  bar_pos + Vector2(0,draw_height),Color.white,2.0)

func update_zoom():
	hzoom = clamp(hzoom,min_zoom,max_zoom)
	space_between_bars = horizontal_scale * hzoom
	var bpm_factor = 100 as float / bpm
	total_size = (space_between_bars * bars / timesig_denominator * bpm_factor) + 2
	update()

func _draw():
	clear_background()
	draw_beats()
	draw_bars()
