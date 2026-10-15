@tool
extends AnimationHandler

class_name AnimationPlayerHandler

@export var animation_player : AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(func(anim_name): on_animation_finished.emit(anim_name))

func start_animation(animation : String):
	animation_player.play(animation)

func cancel_animation():
	if animation_player and animation_player.has_animation("RESET"):
		animation_player.play("RESET")
