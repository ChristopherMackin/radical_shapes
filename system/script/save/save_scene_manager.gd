@tool
extends Node

class_name SaveSceneManager

@export var save_data_list : Array[SaveData]:
	set(val):
		save_data_list = Util.auto_populate_resource_array(save_data_list, val, SaveData, "New Save Data")

@export_category("Settings")
@export_enum("Resource Setting", "Save", "Don't Save") var save_data_override: int = 0
@export_enum("Resource Setting", "Load", "Don't Load") var load_data_override: int = 0
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
			if (data.should_load_data || load_data_override == 1) and !load_data_override == 2:
				data.load_data()
			SaveDataGlobalList.loaded_data.append(data.resource)

func save_data():
	for data : SaveData in save_data_list:
		if (data.should_save_data || save_data_override == 1) and !save_data_override == 2:
			data.save_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if save_on_project_stop:
			save_data()
