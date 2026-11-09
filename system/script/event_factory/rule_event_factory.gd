@tool
extends EventFactory

class_name RuleEventFactory

@export var rule: Rule:
	get: return method.rule
	set(val): method.rule = val

@export var event: Event:
	get: return method.product
	set(val): method.product = val

func _init():
	method = RuleFactoryMethod.new()
