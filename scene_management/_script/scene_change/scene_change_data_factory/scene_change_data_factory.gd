class_name SceneChangeDataFactory
extends Resource

var method: FactoryMethod

func get_scene_change_data(query: Dictionary) -> SceneChangeData:
	return method.produce(query)

func produce(query: Dictionary):
	return get_scene_change_data(query)
