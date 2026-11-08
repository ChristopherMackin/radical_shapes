@tool
extends Node

class_name SceneLoadManager

signal on_scene_added

@export_category("Dependencies")
@export_group("Event")
@export var event_manager: EventManager
@export var event_factory: EventFactory
@export var blackboard: Blackboard
@export_group("Scene State")
@export var scene_animator: AnimationPlayer
@export_group("Character Spawn")
@export var character_controllers: Array[CharacterBody3D]
@export var spawn_locations: Array[Node3D]

@export_category("Scene State")
@export var rule_scene_loaders: Array[RuleSceneLoader]:
	set(val):
		rule_scene_loaders = Util.auto_populate_resource_array(rule_scene_loaders, val, RuleSceneLoader)

func _scene_ready():
	if Engine.is_editor_hint(): return;
	
	SceneManager.on_scene_added.connect(_on_scene_added)
	
	var scene_loader: SceneLoader = DefaultSceneLoader.new()
	
	for rsl in rule_scene_loaders:
		if !rsl.rule || rsl.rule.check(Global.blackboard.get_query()): scene_loader = rsl.scene_loader
	
	await scene_loader.set_scene_state(self)

func _on_scene_added(name: String):
	await query_event()
	
	on_scene_added.emit()
	
	queue_free()

func query_event():
	if !event_factory: return
	var bb = blackboard if blackboard else Global.blackboard
	
	var query : Dictionary
	query[Flag.name(Flag.CONCEPT)] = Const.Concept.ON_SCENE_ENTER
	query.merge(bb.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	await event_manager.start_event(event, bb)
