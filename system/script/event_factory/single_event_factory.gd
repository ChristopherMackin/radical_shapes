@tool
extends EventFactory

class_name SingleEventFactory

@export var event: Event:
	get: return method.product
	set(val): method.product = val

func _init():
	method = SingleFactoryMethod.new()
