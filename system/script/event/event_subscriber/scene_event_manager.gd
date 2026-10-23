@tool
extends EventSubscriber

class_name SceneEventManager

@export var scene_animator_handler: AnimationHandler

@export var dialogue_areas: Array[DialogueArea]

@export var input_manager: InputManager
@export var dialogue_input_handler: InputHandler
var replaced_input_handler: InputHandler

var await_event: bool

signal continue_dialogue
signal skip

func _ready():
	super._ready()
	_dialogue_setup()

func _dialogue_setup():
	_refresh_actor_list()
	
	for area in dialogue_areas:
		area.visible = false
	
	if dialogue_input_handler and !Engine.is_editor_hint(): 
		dialogue_input_handler.on_handle_input.connect(_handle_input)

func _handle_input(_delta, input):
	if input.is_action_just_pressed("action_1"):
		continue_dialogue.emit()
	if input.is_action_just_pressed("cancel"):
		continue_dialogue.emit()
		skip.emit()

func _start_event(event: Event):
	await_event = event.await_event
	if !await_event: return
	
	if Engine.is_editor_hint(): return
	replaced_input_handler = input_manager.active_handler
	input_manager.active_handler = dialogue_input_handler

func _end_event(event: Event):
	if !await_event: return
	
	if Engine.is_editor_hint(): return
	input_manager.active_handler = replaced_input_handler

func display_dialogue(dp: DialoguePayload):
	dialogue_canceled = false
	
	var current_actor: Actor = null
	
	if dp.actor != "":
		var index = get_actor_index(dp.actor)
		if index < 0:
			push_error("MISSING LINE \nACTOR: \"%s\"\n LINE: %s" % [dp.actor, dp.line])
			return
		current_actor = actors[index]
	
	var index = dp.dialogue_area_index if dp.dialogue_area_index < dialogue_areas.size() else 0
	
	var dialogue_area: DialogueArea = dialogue_areas[index]
	
	if current_actor:
		current_actor.focus_actor(true)
		if current_actor is CharacterActor:
			current_actor.talk_override = dp.talk
		dialogue_area.skip_to_the_end()
		dialogue_area.set_text(dp.line, current_actor.display_name)
	
	else:
		dialogue_area.skip_to_the_end()
		dialogue_area.set_text(dp.line)
	
	dialogue_area.visible = true
	
	await Util.await_any([
		func(): await dialogue_area.on_dialogue_finished,
		func(): await skip,
		func(): await _on_dialogue_canceled
	])
	
	if dialogue_canceled: return
	
	dialogue_area.skip_to_the_end()
	
	if current_actor && current_actor is CharacterActor:
		current_actor.talk_override = false
	
	var continue_trigger: Callable
	
	if await_event && dp.await_input: continue_trigger = func(): await continue_dialogue
	else: continue_trigger = func(): await Global.create_timer(dp.close_timer)
	
	await Util.await_any([
		continue_trigger,
		func(): await _on_dialogue_canceled
	])
	
	if dialogue_canceled: return
	
	dialogue_area.visible = false
	
	if current_actor:
		current_actor.focus_actor(false)

func cancel_dialogue(actor):
	for area in dialogue_areas:
		area.visible = false
	
	if actor != "":
		var index = get_actor_index(actor)
		var current_actor = actors[index]
		
		current_actor.focus_actor(false)
		
	dialogue_canceled = true
	_on_dialogue_canceled.emit()

func play_animation(animation : String, actor : String, overwrite_animation: bool, await_animation : bool):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
		
	animation_handler.start_animation(animation)
	
	if await_animation:
		var finished_animation: String = await animation_handler.on_animation_finished
		while finished_animation.split("/")[-1] != animation:
			finished_animation = await animation_handler.on_animation_finished
			print("finished_animation")

func cancel_animation(actor):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))
	
	else:
		animation_handler = scene_animator_handler
	
	animation_handler.cancel_animation()

func get_actor_index(actor_name : String) -> int:
	return actors.map(func(x): return x.actor_name.to_snake_case()).find(actor_name.to_snake_case())
