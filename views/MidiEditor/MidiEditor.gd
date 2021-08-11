tool
extends Control
class_name MidiEditor

var previous_h_scroll : float
var h_scrollbar : HScrollBar
var v_scrollbar : VScrollBar
var hzoom : float = 1
var vzoom : float = 1

export var horizontal_increments : float
export var vertical_increments : float

export var zoom_steps : float = 0.2

export var max_h_zoom : float = 20
export var min_h_zoom : float = 10
export var max_v_zoom : float = 5
export var min_v_zoom : float = 2

export var horizontal_scale : float = 100
export var vertical_scale : float = 7

export var max_bar_count : int = 150

export(Resource) var midi_clip

var playback_time : float = 0.0
var beat_time : float
var clip_time : float
onready var midi_editor_view = $MidiEditorView

func _ready():
	midi_editor_view.update_midiclip(midi_clip)
	h_scrollbar = get_node("HScrollBar")
	v_scrollbar = get_node("VScrollBar")
	v_scrollbar.connect("value_changed",self,"update_offsets")
	h_scrollbar.connect("value_changed",self,"update_offsets")
	connect("resized",self,"update_draw_area")
	get_tree().get_root().connect("size_changed", self, "update_draw_area")
	hzoom = max(min_h_zoom,max_h_zoom / 2)
	vzoom = max(min_v_zoom,max_v_zoom / 2)
	beat_time = beat_to_seconds(midi_clip.bpm,midi_clip.timesig_numerator)
	clip_time = beat_time * midi_clip.beats
	update_offsets(0)
	v_scrollbar.value = Globals.octaves.OCTAVE_3 * Globals.octave_keys.KEY_COUNT * (vertical_scale * hzoom)

func beat_to_seconds(bpm,time_sig) -> float:
	return 60 / (bpm)


func _input(event):
		if Input.is_action_pressed("control"):
			if Input.is_action_pressed("shift"):
				var previous_max_value = h_scrollbar.max_value
				var previous_value = h_scrollbar.value
				if Input.is_action_pressed("scroll_up"):
					hzoom += zoom_steps
				elif Input.is_action_pressed("scroll_down"):
					hzoom -= zoom_steps
				h_scrollbar.max_value = midi_editor_view.total_horizontal_size
				h_scrollbar.value = previous_value * h_scrollbar.max_value / previous_max_value
				update_draw_area()
			else:
				var previous_max_value = v_scrollbar.max_value
				var previous_value = v_scrollbar.value
				if Input.is_action_pressed("scroll_up"):
					vzoom += zoom_steps
				elif Input.is_action_pressed("scroll_down"):
					vzoom -= zoom_steps
				update_draw_area()
				v_scrollbar.max_value = midi_editor_view.total_vertical_size
				v_scrollbar.value = previous_value * v_scrollbar.max_value / previous_max_value
		else:
			if Input.is_action_pressed("shift"):
				if Input.is_action_pressed("scroll_up"):
					h_scrollbar.value -= horizontal_increments
				if Input.is_action_pressed("scroll_down"):
					h_scrollbar.value += horizontal_increments
				update_draw_area()
			else:
				if Input.is_action_pressed("scroll_up"):
					v_scrollbar.value -= vertical_increments
				if Input.is_action_pressed("scroll_down"):
					v_scrollbar.value += vertical_increments
				update_draw_area()

func update_draw_area():
	update_zoom()
	midi_editor_view.bar_count = max_bar_count
	h_scrollbar.max_value = midi_editor_view.total_horizontal_size
	h_scrollbar.page =  midi_editor_view.rect_size.x
	v_scrollbar.max_value = midi_editor_view.total_vertical_size
	v_scrollbar.page =  midi_editor_view.rect_size.y
	midi_editor_view.update()
	update_zoom()

func update_offsets(value):
	midi_editor_view.update_offsets(h_scrollbar.value,v_scrollbar.value)
	update_draw_area()

func update_zoom():
	hzoom = clamp(hzoom,min_h_zoom,max_h_zoom)
	vzoom = clamp(vzoom,min_v_zoom,max_v_zoom)
	var bpm_factor = 100 as float / midi_clip.bpm
	midi_editor_view.update_scale(Vector2(horizontal_scale * hzoom,vertical_scale * vzoom))
	midi_editor_view.total_horizontal_size =  (horizontal_scale * hzoom * Globals.default_ticks_per_bar * max_bar_count * bpm_factor) + 20
	midi_editor_view.total_vertical_size = vertical_scale * vzoom * Globals.octaves.OCTAVE_COUNT * 12 
