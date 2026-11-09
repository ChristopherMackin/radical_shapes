class_name SceneChangeDataFactory
extends Resource

var method: FactoryMethod

func get_scene_change_data(_query: Dictionary) -> SceneChangeData:
	return method.produce(_query)
