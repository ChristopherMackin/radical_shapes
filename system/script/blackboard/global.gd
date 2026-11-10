@tool
extends Node

@export var blackboard : Blackboard:
	set(val):
		Util.optional_disconnect(blackboard, "blackboard_updated", _on_blackboard_updated)
		blackboard = val
		Util.optional_connect(blackboard, "blackboard_updated", _on_blackboard_updated)

var global_timers: Dictionary[String, Dictionary]

signal blackboard_updated
signal on_global_timer_timeout(name: String)
signal on_global_timer_started(name: String)

var actors: Array[Actor]

var state_nodes: Array[StateNode]:
	get():
		var state_nodes: Array[StateNode]
		state_nodes.assign(get_tree().root.find_children("*", "StateNode", true, false))
		return state_nodes

func _on_blackboard_updated():
	blackboard_updated.emit()

func _notification(what: int) -> void:
	if Engine.is_editor_hint(): return
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await Global.create_timer(.01)
		get_tree().quit()

func create_timer(seconds : float):
	await get_tree().create_timer(seconds).timeout

func create_global_timer(seconds: float, name: String = "global_timer", overwrite: bool = true):
	if global_timers.has(name):
		if overwrite:
			var timer = global_timers[name]["timer"]
			global_timers.erase(name)
			timer.timeout.emit()
		else:
			return
	
	var timer = get_tree().create_timer(seconds)
	
	global_timers[name] = {}
	global_timers[name]["timer"] = timer
	global_timers[name]["durration"] = seconds
	on_global_timer_started.emit(name)
	
	await timer.timeout
	
	if !global_timers.has(name): return
	
	global_timers.erase(name)
	
	on_global_timer_timeout.emit(name)

func get_global_timer_normalized_time(name: String = "global_timer") -> float:
	if !global_timers.has(name): return -1
	
	var timer_object = global_timers[name]
	var durration: float = timer_object["durration"]
	var time_left = timer_object["timer"].time_left
	
	return (durration - time_left) / durration

func process_frame():
	await get_tree().process_frame

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	if Engine.is_editor_hint(): return
	get_tree().set_auto_accept_quit(false)

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
