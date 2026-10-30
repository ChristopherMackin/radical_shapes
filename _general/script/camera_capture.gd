class_name CameraCapture
extends Area3D

@export var phantom_camera: PhantomCamera3D
@export var camera_priority: int = 2
var starting_priority: = 0
@export var target: Node3D

func _ready() -> void:
	if !phantom_camera: 
		queue_free()
		return
	
	starting_priority = phantom_camera.priority
	monitoring = true
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_area_entered(area: Area3D) -> void:
	if target == area:
		phantom_camera.priority = camera_priority

func _on_area_exited(area: Area3D) -> void:
	if target == area:
		phantom_camera.priority = starting_priority

func _on_body_entered(body: Node3D) -> void:
	if target == body:
		phantom_camera.priority = camera_priority

func _on_body_exited(body: Node3D) -> void:
	if target == body:
		phantom_camera.priority = starting_priority
