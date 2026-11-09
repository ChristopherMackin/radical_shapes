@tool
class_name RuleSceneChangeDataFactory
extends SceneChangeDataFactory

@export var rule: Rule:
	get: return method.rule
	set(val): method.rule = val

@export var scene_change_data: SceneChangeData:
	get: return method.product
	set(val): method.product = val

func _init():
	method = RuleFactoryMethod.new()
