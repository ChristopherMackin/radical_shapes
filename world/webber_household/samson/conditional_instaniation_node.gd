class_name ConditionalInstantiationNode
extends Node

@export var rule: Rule
var placeholders: Array[InstancePlaceholder] = []

func _ready():
	if !rule || !rule.check(Global.blackboard.get_query()):
		queue_free()
		return
	
	for child in get_children():
		if child is InstancePlaceholder:
			placeholders.append(child)
	
	for placeholder in placeholders:
		var node = placeholder.create_instance(true)
		Util.set_parent(node, get_parent())
	
	queue_free()
