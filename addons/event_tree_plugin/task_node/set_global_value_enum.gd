@tool
class_name SetGlobalValueEnum

extends Node

@export var flag_option_button: OptionButton
@export var expiration_option_button: OptionButton

func _ready() -> void:
	var expiration = {"None": 0}
	expiration.merge(Blackboard.ExpirationToken as Dictionary)
	
	_populate_dropdown(flag_option_button, Flag.Flag)
	_populate_dropdown(expiration_option_button, expiration)

func _populate_dropdown(dropdown: OptionButton, enumeration: Dictionary) -> void:
	dropdown.clear() # Clear default editor items if any
	
	# Loop through the enum keys and add them as dropdown options
	for key in enumeration.keys():
		dropdown.add_item(key, enumeration[key])
