class_name ReturnToSceneChangeNode
extends SceneChangeNode

func transition_scene():
	var scene_index = Global.blackboard.get_flag_value(Flag.SPAWN_INDEX)
	if !scene_index:
		super.transition_scene()
		return
	
	_save_scene_state()
	SceneManager.replace_scene_by_index_async(scene_index, scene_change_data.transition)
