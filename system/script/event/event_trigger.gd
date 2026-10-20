extends Node

class_name EventTrigger

@export var event_manager: EventManager
@export var event_factory: EventFactory
@export var blackboard: Blackboard

func query_event():
	var bb = blackboard if blackboard else Global.blackboard
	
	var query : Dictionary
	query[Flag.name(Flag.CONCEPT)] = Const.Concept.ON_EVENT_TRIGGER_INVOKED
	query.merge(bb.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	await event_manager.start_event(event, bb)
