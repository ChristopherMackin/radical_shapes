extends Node

class_name EventSubscriber

@export var manager : EventManager:
	set(val):
		if manager:
			manager.unsubscribe(self)
		
		manager = val
		
		if manager:
			manager.subscribe(self)

signal _on_dialogue_canceled
var dialogue_canceled: bool = false
var actors: Array[Actor]:
	get(): return _actors.filter(func(x): return x != null)
var _actors: Array[Actor]

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		if manager:
			manager.unsubscribe(self)

func _ready():
	if Engine.is_editor_hint(): return
	_refresh_actor_list()

func _start_event(_event: Event):
	pass

func _end_event(_event: Event):
	pass

func display_dialogue(_dp: DialoguePayload):
	pass

func cancel_dialogue(_actor : String):
	pass

func play_animation(_animation : String, _actor : String, _overwrite_animation: bool, _await_animation: bool):
	pass

func cancel_animation(_actor : String):
	pass

signal _on_timer_canceled

func start_timer(seconds: float):
	await Util.await_any([
		func(): await Global.create_timer(seconds),
		func(): await _on_timer_canceled
	])

func cancel_timer():
	_on_timer_canceled.emit()

func _refresh_actor_list():
	_actors.clear()
	
	if Engine.is_editor_hint():
		_actors.assign(get_tree().edited_scene_root.find_children("*", "Actor", true, false))
	else:
		_actors.assign(get_tree().root.find_children("*", "Actor", true, false))
	
	for actor in _actors:
		if _actors.filter(func(x): return actor.actor_name == x.actor_name).size() > 1:
			push_error("ERROR: Two actors share a name -> \n Node: %s \n Actor Name: %s" % [actor.name, actor.actor_name])
