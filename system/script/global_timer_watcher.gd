class_name GlobalTimerWatcher
extends Node

signal on_global_timer_timeout(name: String)

@export var filter: Array[String]

func _ready() -> void:
	Global.on_global_timer_timeout.connect(_emit_on_global_timer_timeout)

func _emit_on_global_timer_timeout(name: String):
	if !filter || filter.has(name):
		on_global_timer_timeout.emit(name)

func test(name: String):
	print(name)
