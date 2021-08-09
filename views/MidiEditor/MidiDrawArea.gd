tool
extends Control
class_name MidiDrawArea

export var timesig_numerator : int = 4
export var timesig_denominator : int = 4
export var bpm : int = 120
export var horizontal_scale : float = 50
export var bars : int
export var zoom_steps : float = 0.2
export var max_zoom : float = 10


onready var timesig : float = timesig_numerator as float / timesig_denominator
onready var hzoom : float = 1
onready var vzoom : float = 1

var vertical_offset : int
var horizontal_offset : int
var draw_width : int
var draw_height : int


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_min_size.x = horizontal_scale * bars
	rect_min_size.y = 700

func clear_background():
	draw_rect(Rect2(Vector2(horizontal_offset,vertical_offset),Vector2(draw_width,draw_height)),Color.black)

func draw_bars():
	var space_between_bars : float = rect_size.x as float / bars
	for i in range(0,bars):
		if i * horizontal_scale >= horizontal_offset and i * horizontal_scale <= horizontal_offset + draw_width:
			var line_pos : Vector2 = Vector2(space_between_bars * i,vertical_offset)
			draw_line(line_pos,line_pos + Vector2(0,draw_height),Color.white)

func _draw():
	clear_background()
	draw_bars()
