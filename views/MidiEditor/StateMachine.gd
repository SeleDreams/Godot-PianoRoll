extends Node
class_name StateMachine

var _state : State
var _state_name : String
export var target_nodepath : NodePath
export var initial_state : NodePath
var _target_node

func _ready():
	_target_node = get_node(target_nodepath)

func transition_to_state(new_state : String,msg := {}):
	var new_state_node = get_node(new_state)
	_state_name = new_state
	assert(new_state_node)
	if _state:
		_state.exit()
	_state = new_state_node
	_state.enter(msg)
	
func _input(event):
	if _state:
		_state.input(event)
	else:
		transition_to_state(initial_state)
