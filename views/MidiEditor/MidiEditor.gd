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
export(ButtonGroup) var quantization_buttons

var bpm_factor : float
var midi_editor_view

var state_machine : StateMachine

var quantization : int = 16
var length_quantization : int = 16


func _ready():
	state_machine = $StateMachine
	init_quantization_buttons()
	bpm_factor = 100 as float / midi_clip.bpm
	midi_editor_view = $MidiEditorView
	midi_editor_view.midi_editor = self
	h_scrollbar = midi_editor_view.get_node("HScrollBar")
	v_scrollbar = midi_editor_view.get_node("VScrollBar")
	v_scrollbar.connect("value_changed",self,"update_offsets")
	h_scrollbar.connect("value_changed",self,"update_offsets")
	connect("resized",self,"update_draw_area")
	get_tree().get_root().connect("size_changed", self, "update_draw_area")
	hzoom = max(min_h_zoom,max_h_zoom / 4)
	vzoom = max(min_v_zoom,max_v_zoom / 1.5)
	update_offsets(0)
	v_scrollbar.value = Globals.octaves.OCTAVE_3 * Globals.octave_keys.KEY_COUNT * (vertical_scale * vzoom)


func init_quantization_buttons():
	var buttons = quantization_buttons.get_buttons()
	for button in buttons:
		var option_button : OptionButton = button
		for i in range(0,129,2):
			if i == 0:
				i = 1
			option_button.add_item("1/%d" % (i ))
		option_button.select(8)

func save(output_path : String):
	midi_clip.s

func _input(event):
	if not midi_editor_view.hovered:
		return
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
	update_zoom()
	midi_editor_view.update()

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

func get_step() -> int:
	return (Globals.ticks_per_bar / midi_clip.timesig_numerator / quantization / (1 / midi_clip.timesig_denominator)) as int
	
func get_length_step() -> int:
	return (Globals.ticks_per_bar / midi_clip.timesig_numerator / length_quantization / (1 / midi_clip.timesig_denominator)) as int

func width_to_ticks(width : float) -> int:
	return (( width / ((horizontal_scale * hzoom) * bpm_factor))) as int

func ticks_to_width(ticks : int):
	return ticks * (horizontal_scale * hzoom) * bpm_factor

func height_to_note(height : int) -> int:
	return (((Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT * (vertical_scale * vzoom)) - height) / (vertical_scale * vzoom)) + 1 as int

func note_to_height(note : int) -> float:
	return  ((Globals.octaves.OCTAVE_COUNT * Globals.octave_keys.KEY_COUNT) - note) * (vertical_scale * vzoom)

func ticks_to_steps(ticks : int):
	var rest = ticks % get_step()
	return ticks - rest

func ticks_to_length_steps(ticks : int):
	var rest = ticks % get_length_step()
	return ticks - rest

func pos_to_grid_pos(pos : Vector2) -> Vector2:
	return Vector2(width_to_ticks(pos.x),height_to_note(pos.y as int))

func mouse_pos_to_grid_pos() -> Vector2:
	var pos = midi_editor_view.get_local_mouse_position() + midi_editor_view.offset
	return pos_to_grid_pos(pos)

func grid_pos_to_local_pos(original : Vector2) -> Vector2:
	return Vector2(ticks_to_width(original.x),note_to_height(original.y)) - midi_editor_view.offset


func _on_Select_toggled(button_pressed):
	if button_pressed:
		state_machine.transition_to_state("HoverNote/SelectNote")


func _on_draw_toggled(button_pressed):
	if button_pressed:
		state_machine.transition_to_state("HoverNote/DrawNote")


func _on_QuantizationDropdown_item_selected(index):
	quantization = index * 2 if index > 0 else 1
	update_draw_area()

func _on_LengthQuantizationDropdown_item_selected(index):
	length_quantization = index * 2 if index > 0 else 1
	update_draw_area()


func _on_RenderButton_button_down():
	var result : bool = $Renderer.render_notes(midi_clip.notes)
	if not result:
		print("An error occurred while synthesizing the notes")


func _on_SaveButton_button_down():
	var dialog_container := $FileDialogContainer
	dialog_container.visible = true
	var file_dialog := dialog_container.get_node("SaveFileDialog")
	file_dialog.popup()

func _on_SaveFileDialog_hide():
	var dialog_container := $FileDialogContainer
	dialog_container.visible = false

func _on_OpenFileDialog_hide():
	var dialog_container := $FileDialogContainer
	dialog_container.visible = false

func _on_SaveFileDialog_file_selected(path):
	var midi_serialized : Dictionary = midi_clip.serialize()
	var json_string : String = JSON.print(midi_serialized)
	var output_file : File = File.new()
	output_file.open(path,File.WRITE)
	output_file.store_string(json_string)
	output_file.close()


func _on_OpenFileDialog_file_selected(path):
	var file : File = File.new()
	file.open(path,File.READ)
	var json = file.get_as_text()
	var deserialized_dic : Dictionary = JSON.parse(json).result
	midi_clip = MidiClip.new()
	midi_clip.deserialize(deserialized_dic)


func _on_OpenButton_button_down():
	var dialog_container := $FileDialogContainer
	dialog_container.visible = true
	var file_dialog := dialog_container.get_node("OpenFileDialog")
	file_dialog.popup()


