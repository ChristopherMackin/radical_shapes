@tool
class_name IntMatchBucketSceneChangeDataFactory
extends SceneChangeDataFactory

@export var flag: Flag.Flag:
	get: return method.flag
	set(val): method.flag = val

@export var default_data: SceneChangeData:
	get: return method.default_product
	set(val): method.default_product = val

@export var data: Array[SceneChangeData]:
	get: 
		var mb: Array[SceneChangeData]
		mb.assign(method.products)
		return mb
	set(val): method.products.assign(val)

func _init():
	method = IntMatchBucketFactoryMethod.new()
