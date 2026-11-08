@tool
extends Actor

class_name CharacterActor

signal on_set_talking(val: bool)

@export var _layer_mask: LayerMask
@export var _dialgoue_camera: PhantomCamera3D
@export var _look_at_modifier: LookAtModifier3D

@export var character_animation_tree: CharacterAnimationTree

@export var talk_override: bool = false:
	get():
		if character_animation_tree:
			return character_animation_tree.talk_override
		return false
	set(val):
		if character_animation_tree: character_animation_tree.talk_override = val

@export var blink_override: bool = false:
	get():
		if character_animation_tree:
			return character_animation_tree.blink_override
		return false
	set(val):
		if character_animation_tree: character_animation_tree.blink_override = val

@export var look_at_override: bool = false:
	set(val):
		look_at_override = val
		if true && _look_at_modifier:
			_look_at_modifier.target_node = NodePath()

func focus_actor(val: bool):
	if val:
		_layer_mask.set_layer(20, true)
		_dialgoue_camera.priority = 1
	else:
		_layer_mask.set_layer(20, false)
		_dialgoue_camera.priority = 0

func focus_look_at_body_shape(_area_rid, body: Node3D, body_shape_index, _local_shape_index):
	if !_look_at_modifier || _look_at_modifier.target_node != NodePath() || look_at_override: return
	
	_look_at_modifier.target_node = get_shape_node_path(body, body_shape_index)

func unfocus_look_at_body_shape(_area_rid, body: Node3D, body_shape_index, _local_shape_index):
	if !_look_at_modifier || look_at_override: return
	
	var path := get_shape_node_path(body, body_shape_index)
	
	if _look_at_modifier.target_node == path:
		_look_at_modifier.target_node = NodePath()

func focus_look_at_area_shape(_area_rid, area: Area3D, area_shape_index, _local_shape_index):
	if !_look_at_modifier || _look_at_modifier.target_node != NodePath() || look_at_override: return
	
	_look_at_modifier.target_node = get_shape_node_path(area, area_shape_index)

func unfocus_look_at_area_shape(_area_rid, area: Area3D, area_shape_index, _local_shape_index):
	if !_look_at_modifier || look_at_override: return
	
	var path := get_shape_node_path(area, area_shape_index)
	
	if _look_at_modifier.target_node == path:
		_look_at_modifier.target_node = NodePath()

func get_shape_node_path(shape: Node3D, index) -> NodePath:
	if !shape: return NodePath()
	
	var owner = shape.shape_find_owner(index)
	var node = shape.shape_owner_get_owner(owner)
	
	return node.get_path() if node.is_inside_tree() else NodePath()
	
