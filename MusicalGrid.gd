tool
extends Control
class_name MusicalGrid

export var bar_color : Color
export var beat_color : Color
export var quantization_color : Color
export var background_color : Color
export var timeline_background : Color
export var timeline_foreground : Color
export var timeline_height : float
export var timeline_font : Font

var offset : Vector2
var vertical_scale : float
var horizontal_scale : float
var total_horizontal_size : float
var total_vertical_size : float
var bar_count : int
var clip : MidiClip

func clear_background():
	draw_rect(Rect2(Vector2.ZERO,Vector2(rect_size.x,rect_size.y)),background_color)

func draw_beats():
	var bpm_factor = 100 as float / clip.bpm
	var ticks = Globals.default_ticks_per_bar / clip.timesig_numerator
	for i in range(1,bar_count * clip.timesig_numerator + 1):
			var beat_pos = Vector2(horizontal_scale * ticks * bpm_factor * i - offset.x,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,rect_size.y),beat_color,2.0)

func draw_quantization():
	var bpm_factor = 100 as float / clip.bpm
	var quantization = clip.get_quantization()
	var ticks = Globals.default_ticks_per_bar / quantization * clip.timesig_numerator
	for i in range(1,(bar_count / clip.timesig_numerator) * quantization ):
			var beat_pos = Vector2(horizontal_scale * ticks * bpm_factor * i - offset.x,0)
			if beat_pos.x < rect_size.x and beat_pos.x > 0:
				draw_line(beat_pos,beat_pos + Vector2(0,rect_size.y),quantization_color,1.0)

func draw_bars():
	var bpm_factor = 100 as float / clip.bpm
	var ticks = Globals.default_ticks_per_bar
	for i in range(0,bar_count + 1):
		var bar_pos = Vector2(horizontal_scale * ticks * bpm_factor * i - offset.x ,0)
		if bar_pos.x < rect_size.x and bar_pos.x > 0:
			draw_line(bar_pos,bar_pos + Vector2(0,rect_size.y),bar_color,3.0)

func draw_timeline():
	var bpm_factor = 100 as float / clip.bpm
	var ticks = Globals.default_ticks_per_bar
	draw_rect(Rect2(Vector2.ZERO,Vector2(rect_size.x,timeline_height)),timeline_background)
	for i in range(0,bar_count + 1):
		var bar_pos = Vector2(horizontal_scale * ticks * bpm_factor * i - offset.x,0)
		draw_line(bar_pos + Vector2(0,timeline_height / 5),bar_pos + Vector2(0,timeline_height - timeline_height / 5),timeline_foreground,2.0)
		draw_string(timeline_font,bar_pos + Vector2(5,15),String(i+1),timeline_foreground)

func draw_grid():
		draw_quantization()
		draw_beats()
		draw_bars()

func _draw():
	clear_background()
	if (clip != null):
		draw_grid()
		draw_timeline()
