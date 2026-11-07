class_name GlobalTimerWatcher
extends Node

signal on_global_timer_timeout(name: String)

@export var timer_name: String = "global_timer"

func _ready() -> void:
	Global.on_global_timer_timeout.connect(_emit_on_global_timer_timeout)

func _process(delta):
	var normalized_time = Global.get_global_timer_normalized_time(timer_name)
	if normalized_time == -1: return
	print(normalized_time)

func _emit_on_global_timer_timeout(name: String):
	if name == timer_name:
		on_global_timer_timeout.emit(name)
		queue_free()
