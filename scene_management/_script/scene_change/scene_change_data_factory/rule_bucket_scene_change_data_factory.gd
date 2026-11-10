@tool
class_name RuleBucketSceneChangeDataFactory
extends BucketSceneChangeDataFactory

@export var rule: Rule:
	get: return method.rule
	set(val): method.rule = val

func _init():
	method = RuleBucketFactoryMethod.new()
