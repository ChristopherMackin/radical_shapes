@tool
extends AnimationHandler

class_name SimpleCharacterTreeAnimationHandler

@export var animation_tree: CharacterAnimationTree

var animation: Animation:
	set(val):
		if !animation_tree || val == null: return
		var path = Util.get_animation_library_path_from_animation(_animation_player, val)
		if path: start_animation(path)

var _animation_player: AnimationPlayer:
	get(): 
		if !animation_tree: return null
		return animation_tree.get_node(animation_tree.anim_player)

func start_animation(name : String):
	if !animation_tree || !animation_tree.anim_player: return
	
	#print(animation_tree.get_node(animation_tree.anim_player).get_animation_list())
	
	if _animation_player.has_animation(name):
		var anim_node: AnimationNode = animation_tree.tree_root.get_node("Animation")
		if anim_node.animation != name:
			anim_node.animation = name

func cancel_animation():
	if !animation_tree || !animation_tree.anim_player: return
	
	if animation_tree.get_node(animation_tree.anim_player).has_animation("RESET"):
		animation_tree.tree_root.get_node("Animation").animation = "RESET"
