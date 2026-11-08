extends Node

signal on_scene_change_start
signal on_scene_change_end
signal on_scene_removed(scene_name: String)
signal on_scene_added(scene_name: String)

var loaded_scenes: Dictionary[int, Array]
var canvas: CanvasLayer
var dont_destroy_on_load: Node3D

@export_global_file("*.tscn") var _scene_list: Array[String]
var scene_list: Array[String]:
	get: return _scene_list

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	var node = get_tree().current_scene
	var scene_index = _scene_list.find_custom(func(x): return Util.get_file_name(x) == node.name)
	loaded_scenes[scene_index] = [node]
	
	canvas = CanvasLayer.new()
	canvas.layer = 10
	canvas.name = "GlobalCanvas"

	dont_destroy_on_load = Node3D.new()
	dont_destroy_on_load.name = "DontDestroyOnLoad"
	
	get_tree().current_scene = self
	add_child(canvas)
	add_child(dont_destroy_on_load)
	
	if node is Control:
		node.reparent.call_deferred(canvas)
	else:
		node.reparent.call_deferred(self)
	
	await Util.await_predicate(func(): 
		var parent = node.get_parent()
		return parent == self or parent == canvas
	)
	
	initialize_loaded_scene(node)


func replace_scene_async(scene_name: String, transition: PackedScene = null) -> bool:
	var scene_index = _scene_list.find_custom(func(x): return Util.get_file_name(x) == scene_name)
	if scene_index == -1: 
		push_error("ERROR: SCENE NOT REGISTERED IN SCENE MANAGER")
		return false
	
	return await replace_scene_by_index_async(scene_index, transition)

func replace_scene_by_index_async(scene_index: int, transition: PackedScene = null):
	if scene_index <0 || scene_index >= _scene_list.size(): return false
	
	Global.blackboard.add_flag(Flag.CURRENT_LOCATION, scene_index)
	on_scene_change_start.emit()
	
	var free_functions: Array[Callable] = []
	for key in loaded_scenes:
		for node: Node in loaded_scenes[key]:
			free_functions.append(func():
				var name = node.name
				node.queue_free()
				await node.tree_exited
				on_scene_removed.emit(name)
			)
	
	if transition != null:
		var transition_instance = transition.instantiate()
		if transition_instance is SceneTransition:
			canvas.add_child(transition_instance)
			await transition_instance.start_transition_out()
			
			await Util.await_all(free_functions)
			loaded_scenes.clear()
			
			instantiate_scene_by_index.call_deferred(scene_index)
			
			await transition_instance.start_transition_in()
			transition_instance.queue_free()
		else:
			transition_instance.queue_free()
			
			await Util.await_all(free_functions)
			loaded_scenes.clear()
		
			instantiate_scene_by_index.call_deferred(scene_index)
	else:
		await Util.await_all(free_functions)
		loaded_scenes.clear()
		
		instantiate_scene_by_index.call_deferred(scene_index)
	
	on_scene_change_end.emit()
	return true

func instantiate_scene_by_index(scene_index: int):
	var scene: PackedScene = load(_scene_list[scene_index])
	
	var instance = scene.instantiate()
	
	if instance is Control:
		canvas.add_child(instance)
	else:
		add_child(instance)
	
	await Util.await_predicate(func(): 
		var parent = instance.get_parent()
		return parent == self or parent == canvas
	)
	
	initialize_loaded_scene(instance)
	
	if !loaded_scenes.has(scene_index): loaded_scenes[scene_index] = []
	loaded_scenes[scene_index].append(instance)

func add_dont_destroy_on_load(node: Node) -> void:
	Util.set_parent(node, dont_destroy_on_load)

func initialize_loaded_scene(instance):
	var added_nodes: Array[Node]
	added_nodes.assign(Util.get_all_children(instance) + [instance])
	added_nodes = added_nodes.filter(func(node: Node): return node.has_method("_scene_ready"))
	
	var await_funcs: Array[Callable]
	for n in added_nodes:
		await_funcs.append(func(): await n._scene_ready())
	
	await Util.await_all(await_funcs)
	
	on_scene_added.emit(instance.name)
