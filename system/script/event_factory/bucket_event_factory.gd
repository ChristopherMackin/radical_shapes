@tool
extends EventFactory

class_name BucketEventFactory

@export var buckets: Array[EventFactory]:
	get: 
		var mb: Array[EventFactory]
		mb.assign(method.buckets)
		return mb
	set(val): method.buckets.assign(val)

func _init():
	method = BucketFactoryMethod.new()
