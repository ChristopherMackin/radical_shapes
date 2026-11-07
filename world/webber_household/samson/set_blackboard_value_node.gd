@tool
class_name SetBlackboardValueNode
extends Node

@export var blackboard: Blackboard
@export var flag: Flag.Flag
@export var value: Variant
@export var expiration_flags: int = 0

# This function builds the inspector interface dynamically
func _validate_property(property: Dictionary) -> void:
	if property.name == "expiration_flags":
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = ",".join(Blackboard.ExpirationToken.keys()) # Automatically maps keys to checkboxes

func set_value(value_overwrite = null):
	var val = value_overwrite if value_overwrite else value
	var bb = blackboard if blackboard else Global.blackboard
	
	bb.add_flag(flag, val, expiration_flags)
