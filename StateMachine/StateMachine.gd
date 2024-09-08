class_name StateMachine
extends StateNode

signal active_state_changed(current: StateNode, previous: StateNode)

static var ANYSTATE = StateNode.new().named("StateMachine::ANYSTATE")

var state_map = {
	[ANYSTATE.name]: {}
}
var active_state: StateNode = null
var previous_state: StateNode = null

func add_transition(from_state: StateNode, to_state: StateNode, action: StringName):
	if !state_map.has(from_state.name):
		state_map[from_state.name] = {}
	
	if !state_map[from_state.name].has(action):
		state_map[from_state.name][action] = to_state
	else:
		push_error("Attempt to overwrite transition from %s to %s for action %s" % [from_state.name, to_state.name, action])

func set_active(state: StateNode):
	if !active_state:
		_transition_to(state, active_state)

func _transition_to(new_state: StateNode, state: StateNode):
		active_state = new_state
		if state:
			previous_state = state
			state._exit()
		new_state._enter()
		active_state_changed.emit(new_state, previous_state)

func dispatch(action: StringName):
	if state_map.has(active_state.name):
		var transitions = state_map.get(active_state.name)
		if transitions.has(action):
			_transition_to(transitions.get(action), active_state)
			return
	
	var any_transitions = state_map.get(ANYSTATE.name)
	if any_transitions.has(action):
			_transition_to(any_transitions.get(action), active_state)
			return
	
	print("Unhandled action: %s in current state %s" % [action, active_state.name])

func get_active_state() -> StateNode:
	return active_state

func get_previous_active_state() -> StateNode:
	return previous_state
