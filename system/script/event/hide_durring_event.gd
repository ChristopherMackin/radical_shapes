extends EventSubscriber

@export var node: Node3D
var _just_changed: bool = false
var _hidden: bool = false
var _visibility: bool

func _ready():
	if !node:
		queue_free()
		return
	
	node.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	var val = node.visible
	
	if _just_changed:
		_just_changed = false
		return
	
	_visibility = val
	
	if _hidden && node.visible:
		_just_changed = true
		node.visible = false
	elif node.visible != _visibility:
		_just_changed = true
		node.visible = _visibility


func _start_event(_event: Event):
	_hidden = true
	_just_changed = true
	node.visible = false

func _end_event(_event: Event):
	_hidden = false
	if node.visible != _visibility:
		_just_changed = true
		node.visible = _visibility
