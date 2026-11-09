@tool
class_name BucketSceneChangeDataFactory
extends SceneChangeDataFactory

@export var scene_change_data_factories: Array[SceneChangeDataFactory]

func get_scene_change_data(_query: Dictionary) -> SceneChangeData:
	for factory in scene_change_data_factories:
		var data = factory.get_scene_change_data(_query)
		if data: return data
	
	return null
