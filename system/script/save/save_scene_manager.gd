@tool
extends Node

class_name SaveSceneManager

@export var save_data_list : Array[SaveData]:
	set(val):
		save_data_list = Util.auto_populate_resource_array(save_data_list, val, SaveData, "New Save Data")

@export_category("Settings")
@export var should_save_data_override: bool = false
@export var should_load_data_override: bool = false
@export var save_on_project_stop := false

func _enter_tree():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Util.optional_connect(SceneManager, "on_scene_change", save_data)

func _ready():
	if Engine.is_editor_hint(): return
	load_data()

func load_data():
	for data : SaveData in save_data_list:
		if !SaveDataGlobalList.loaded_data.has(data.resource):
			if data.should_load_data:
				data.load_data()
			SaveDataGlobalList.loaded_data.append(data.resource)

func save_data():
	for data : SaveData in save_data_list:
		if data.should_save_data:
			data.save_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if save_on_project_stop:
			save_data()
