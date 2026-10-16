@tool
extends Node

@export var blackboard : Blackboard:
	set(val):
		Util.optional_disconnect(blackboard, "blackboard_updated", _on_blackboard_updated)
		blackboard = val
		Util.optional_connect(blackboard, "blackboard_updated", _on_blackboard_updated)

signal blackboard_updated
signal on_global_timer_timeout(name: String)

func _on_blackboard_updated():
	blackboard_updated.emit()

func _notification(what: int) -> void:
	if Engine.is_editor_hint(): return
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await Global.create_timer(.01)
		get_tree().quit()

var actors: Array[Actor]

var state_nodes: Array[StateNode]:
	get():
		var state_nodes: Array[StateNode]
		state_nodes.assign(get_tree().root.find_children("*", "StateNode", true, false))
		return state_nodes

func create_timer(seconds : float):
	await get_tree().create_timer(seconds).timeout

func create_global_timer(seconds: float, name: String = "global_timer"):
	await get_tree().create_timer(seconds).timeout
	on_global_timer_timeout.emit(name)

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
