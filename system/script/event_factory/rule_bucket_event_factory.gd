@tool
extends BucketEventFactory
class_name RuleBucketEventFactory

@export var rule: Rule:
	get: return method.rule
	set(val): method.rule = val

func _init():
	method = RuleBucketFactoryMethod.new()
