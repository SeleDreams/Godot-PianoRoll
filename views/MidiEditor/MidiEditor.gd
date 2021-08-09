tool
extends Control

var previous_h_scroll : float
var h_scrollbar : HScrollBar
var v_scrollbar : VScrollBar
export var horizontal_increments : float
export var vertical_increments : float
onready var midi_draw_area : MidiDrawArea = $MidiDrawArea
func _ready():
	h_scrollbar = get_node("HScrollBar")
	v_scrollbar = get_node("VScrollBar")
	v_scrollbar.connect("value_changed",self,"update_offsets")
	h_scrollbar.connect("value_changed",self,"update_offsets")
	connect("resized",self,"update_draw_area")
	get_tree().get_root().connect("size_changed", self, "update_draw_area")
	midi_draw_area.hzoom = min(midi_draw_area.min_h_zoom,midi_draw_area.max_h_zoom / 2)
	midi_draw_area.vzoom = min(midi_draw_area.min_v_zoom,midi_draw_area.max_v_zoom / 2)
	update_draw_area()
	v_scrollbar.value = v_scrollbar.max_value / 2

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_key_pressed(KEY_CONTROL):
			if Input.is_key_pressed(KEY_SHIFT):
				var previous_max_value = h_scrollbar.max_value
				var previous_value = h_scrollbar.value
				if event.button_index == BUTTON_WHEEL_UP:
					midi_draw_area.hzoom += midi_draw_area.zoom_steps
					update_draw_area()
				if event.button_index == BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CONTROL):
					midi_draw_area.hzoom -= midi_draw_area.zoom_steps
					update_draw_area()
				h_scrollbar.max_value = midi_draw_area.total_horizontal_size
				h_scrollbar.value = previous_value * h_scrollbar.max_value / previous_max_value
			else:
				var previous_max_value = v_scrollbar.max_value
				var previous_value = v_scrollbar.value
				if event.button_index == BUTTON_WHEEL_UP:
					midi_draw_area.vzoom += midi_draw_area.zoom_steps
					update_draw_area()
				if event.button_index == BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CONTROL):
					midi_draw_area.vzoom -= midi_draw_area.zoom_steps
					update_draw_area()
				v_scrollbar.max_value = midi_draw_area.total_vertical_size
				v_scrollbar.value = previous_value * v_scrollbar.max_value / previous_max_value
		else:
			if Input.is_key_pressed(KEY_SHIFT):
				if event.button_index == BUTTON_WHEEL_UP:
					h_scrollbar.value -= horizontal_increments
				elif event.button_index == BUTTON_WHEEL_DOWN:
					h_scrollbar.value += horizontal_increments
			else:
				if event.button_index == BUTTON_WHEEL_UP:
					v_scrollbar.value -= vertical_increments
				elif event.button_index == BUTTON_WHEEL_DOWN:
					v_scrollbar.value += vertical_increments

func update_draw_area():
	h_scrollbar.max_value = midi_draw_area.total_horizontal_size
	h_scrollbar.page =  midi_draw_area.rect_size.x
	v_scrollbar.max_value = midi_draw_area.total_vertical_size
	v_scrollbar.page =  midi_draw_area.rect_size.y
	midi_draw_area.draw_width = midi_draw_area.rect_size.x
	midi_draw_area.draw_height =  midi_draw_area.rect_size.y
	midi_draw_area.update_zoom()

func update_offsets(value):
	midi_draw_area.horizontal_offset = h_scrollbar.value
	midi_draw_area.vertical_offset = v_scrollbar.value
	midi_draw_area.update_zoom()
