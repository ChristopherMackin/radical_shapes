class_name Flag
extends Object

enum {
	CONCEPT = 0,
	PLAYER = 1,
	COMPUTER = 2,
	CURRENT_TURN = 3,
	CURRENT_ROUND = 4,
	ACTIVE_CONTESTANT = 5,
	WHICH_CONTESTANT = 6,
	CARD_HISTORY = 7,
	TURN_CARD_HISTORY = 8,
	TOKEN_HISTORY = 9,
	TURN_TOKEN_HISTORY = 10,
	CURRENT_SUIT = 11,
	LINES_CLEARED = 12,
	DEBATES_FINISHED = 13,
	SPAWN_INDEX = 14,
	NUM_CARDS_PLAYED_THIS_TURN = 15,
	TOKENS_PLAYED_THIS_TURN = 16,
	
	#Action Flags
	ACTION_ADDED_CARD_BASE = 17,
	ACTION_VIEWED_CARDS = 18,
	ACTION_MOVED_CARDS_FROM = 19,
	ACTION_DUPLICATE_CARDS_FROM = 20,
	ACTION_MOVED_CARDS_TO = 21,
	ACTION_DUPLICATE_CARDS_TO = 22,
	ACTION_DISCARDED_CARDS = 23,
	ACTION_BANISHED_CARDS = 24,
	ACTION_ADDED_CARD_STATUS_EFFECT = 25,
	
	#Outfit Flags
	JOY_OUTFIT = 26,
	JOY_OUTFIT_VARIANT = 27,
	JOY_IS_WORKING = 28,
	OPAL_OUTFIT = 29,
	
	#System Flags
	STORY_PROGRESS = 30,
	CURRENT_LOCATION = 32,
	SAVED_LOCATION = 34,
	
	#Story Flags
	A1_WAITING_ON_JOY = 31,
	A1_JOY_IS_INTRODUCED = 33,
}

enum Flag{
	CONCEPT = 0,
	PLAYER = 1,
	COMPUTER = 2,
	CURRENT_TURN = 3,
	CURRENT_ROUND = 4,
	ACTIVE_CONTESTANT = 5,
	WHICH_CONTESTANT = 6,
	CARD_HISTORY = 7,
	TURN_CARD_HISTORY = 8,
	TOKEN_HISTORY = 9,
	TURN_TOKEN_HISTORY = 10,
	CURRENT_SUIT = 11,
	LINES_CLEARED = 12,
	DEBATES_FINISHED = 13,
	SPAWN_INDEX = 14,
	NUM_CARDS_PLAYED_THIS_TURN = 15,
	TOKENS_PLAYED_THIS_TURN = 16,
	
	#Action Flags
	ACTION_ADDED_CARD_BASE = 17,
	ACTION_VIEWED_CARDS = 18,
	ACTION_MOVED_CARDS_FROM = 19,
	ACTION_DUPLICATE_CARDS_FROM = 20,
	ACTION_MOVED_CARDS_TO = 21,
	ACTION_DUPLICATE_CARDS_TO = 22,
	ACTION_DISCARDED_CARDS = 23,
	ACTION_BANISHED_CARDS = 24,
	ACTION_ADDED_CARD_STATUS_EFFECT = 25,
	
	#Outfit Flags
	JOY_OUTFIT = 26,
	JOY_OUTFIT_VARIANT = 27,
	JOY_IS_WORKING = 28,
	OPAL_OUTFIT = 29,
	
	#System Flags
	STORY_PROGRESS = 30,
	CURRENT_LOCATION = 32,
	SAVED_LOCATION = 34,
	
	#Story Flags
	A1_WAITING_ON_JOY = 31,
	A1_JOY_IS_INTRODUCED = 33,
}

static func get_all_names() -> Array[String]:
	var current_script: GDScript = load("res://system/script/flag.gd")
	var constant_map: Dictionary = current_script.get_script_constant_map()
			
	return constant_map.keys()

static func name(value: int) -> String:
	var current_script: GDScript = load("res://system/script/flag.gd")
	var constant_map: Dictionary = current_script.get_script_constant_map()
	
	for constant_name in constant_map:
		if constant_map[constant_name] == value:
			return constant_name
			
	return "Unknown"

static func has_value(value: String) -> bool:
	var current_script: GDScript = load("res://system/script/flag.gd")
	var constant_map: Dictionary = current_script.get_script_constant_map()
		
	return constant_map.find_key(value) != -1
