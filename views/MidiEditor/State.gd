extends Node
class_name State

var _parent
var _state_machine

func _ready():
	yield(owner,"ready")
	_parent = get_parent()
	_state_machine = _get_state_machine(self)

func enter(msg := {}):
	pass

func exit():
	pass

func input(event):
	pass

func _get_state_machine(node) -> Node:
	if node == null:
		return null
	return node if node.is_in_group("state_machine") else _get_state_machine(node.get_parent())
