extends Node
class_name RuleSceneChangeNode

signal scene_changed

@export var scene_change_data_factory: SceneChangeDataFactory
@export var await_events: bool = false
@export var event_manager: EventManager

func transition_scene():
	var scene_change_data = scene_change_data_factory.get_scene_change_data(Global.blackboard.get_query())
	if !scene_change_data: return
	
	if await_events:
		await event_manager.wait_for_no_events()
	_save_scene_state(scene_change_data)
	Global.blackboard.add_flag(Flag.SPAWN_INDEX, scene_change_data.next_scene_spawn_index)
	await SceneManager.replace_scene_async(scene_change_data.scene_name, scene_change_data.transition)
	scene_changed.emit()

func _save_scene_state(scene_change_data: SceneChangeData):
	if scene_change_data.save_state:
		for node in Global.state_nodes:
			node.save_state()
		Global.blackboard.add_flag(Flag.SAVED_LOCATION, Global.blackboard.get_flag_value(Flag.CURRENT_LOCATION), Blackboard.ExpirationToken.ON_VALUE_ACCESSED)
