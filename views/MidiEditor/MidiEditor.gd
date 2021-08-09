extends ScrollContainer


onready var midi_draw_area : MidiDrawArea = $MidiDrawArea

func _ready():
	get_v_scrollbar().connect("value_changed",self,"update_offsets")
	get_h_scrollbar().connect("value_changed",self,"update_offsets")
	connect("resized",self,"update_draw_area")
	update_draw_area()

func update_draw_area():
	midi_draw_area.draw_width = rect_size.x
	midi_draw_area.draw_height = rect_size.y

func update_offsets(value):
	midi_draw_area.vertical_offset = scroll_vertical
	midi_draw_area.horizontal_offset = scroll_horizontal
	midi_draw_area.update()
