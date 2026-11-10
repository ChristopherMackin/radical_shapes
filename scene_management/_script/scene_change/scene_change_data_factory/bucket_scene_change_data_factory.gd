@tool
class_name BucketSceneChangeDataFactory
extends SceneChangeDataFactory

@export var scene_change_data_factories: Array[SceneChangeDataFactory]:
	get: 
		var mb: Array[SceneChangeDataFactory]
		mb.assign(method.buckets)
		return mb
	set(val): method.buckets.assign(val)

func _init():
	method = BucketFactoryMethod.new()
