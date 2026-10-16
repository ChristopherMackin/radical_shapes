@tool
class_name ConditionalNode
extends Node

@export var rule: Rule
@export_enum("Destroy", "Hide", "SetVisible") var mode: int
@export var change_on_blackboard_update: bool = true
@export var run_in_editor: bool = true:
	set(val):
		run_in_editor = val
		_set_state()

func _enter_tree() -> void:
	var root = get_parent()
	root.process_mode = Node.PROCESS_MODE_DISABLED
	if Engine.is_editor_hint(): _set_state()

func _ready() -> void:
	Util.optional_connect(Global, "blackboard_updated", _on_blackboard_updated)

func _scene_added():
	_set_state()

func _on_blackboard_updated():
	if !change_on_blackboard_update: return
	_set_state()

func _set_state():
	var root = get_parent()
	if !root: return
	
	if Engine.is_editor_hint() and run_in_editor:
		root.visible = true
		root.process_mode = Node.PROCESS_MODE_INHERIT
		return
	
	var val = rule.check(Global.blackboard.get_query())
	
	if val:
		root.process_mode = Node.PROCESS_MODE_INHERIT
		if mode == 0 or mode == 2: root.visible = true
	
	else:
		root.process_mode = Node.PROCESS_MODE_DISABLED
		match mode:
			0:
				root.visible = false
				if Engine.is_editor_hint(): return
				root.queue_free()
				queue_free()
			_:
				root.visible = false
