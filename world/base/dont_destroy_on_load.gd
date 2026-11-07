class_name DontDestroyOnLoad
extends Node3D

func _ready():
	for child in get_children():
		SceneManager.add_dont_destroy_on_load(child)
	
	queue_free()
