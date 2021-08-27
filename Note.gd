extends Resource
class_name Note

export var note : int
export var pos : int
export var phoneme : String = "ら"
export var length : int
export var velocity : int
export var selected : bool
export var selected_index : int
export var index : int

func get_length() -> int:
	return length

func get_pitch() -> int:
	return note

func get_phoneme() -> String:
	return phoneme

func serialize() -> Dictionary:
	var output : Dictionary = Dictionary()
	output["note"] = note
	output["pos"] = pos
	output["phoneme"] = phoneme
	output["length"] = length
	output["velocity"] = velocity
	output["index"] = index
	return output
	
func deserialize(dic : Dictionary):
	note = dic["note"]
	pos = dic["pos"]
	phoneme = dic["phoneme"]
	length = dic["length"]
	velocity = dic["velocity"]
	index = dic["index"]
	selected_index = -1
	selected = false
