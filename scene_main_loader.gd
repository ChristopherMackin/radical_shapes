extends Node3D

@export var starting_scene: int = 0

func _scene_added() -> void:
	var scene_index = Global.blackboard.get_flag_value(Flag.CURRENT_LOCATION)
	scene_index = scene_index if scene_index else starting_scene
	
	SceneManager.replace_scene_by_index_async(scene_index)
