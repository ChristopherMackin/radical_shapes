@tool
class_name DialogueArea

extends Control

signal on_dialogue_finished

@export_multiline() var text: String:
	get():
		if !scrolling_text: return ""
		return scrolling_text.text
	set(val):
		if !scrolling_text: return
		scrolling_text.text = val
@export var normal_characters_per_second : int:
	get:
		return scrolling_text.characters_per_second if scrolling_text else 0
	set(val):
		if scrolling_text:
			scrolling_text.characters_per_second = val

@export_group("Dependencies")
@export var scrolling_text: ScrollingText:
	set(val):
		Util.optional_disconnect(scrolling_text, "on_scroll_completed", emit_dialogue_complete)
		scrolling_text = val
		Util.optional_connect(scrolling_text, "on_scroll_completed", emit_dialogue_complete)

@export var animation_player: AnimationPlayer:
	get(): return animation_player
	set(val):
		if animation_player && animation_player.current_animation_changed.is_connected(_on_current_animation_changed):
			animation_player.current_animation_changed.disconnect(_on_current_animation_changed)
		
		animation_player = val
		
		if animation_player && !animation_player.current_animation_changed.is_connected(_on_current_animation_changed):
			animation_player.current_animation_changed.connect(_on_current_animation_changed)
@export var speaker_label: RichTextLabel
@export var speaker_control: Control

var anim_name: StringName = ""
var anim: Animation:
	get(): 
		if !animation_player: return
		
		return animation_player.get_animation(anim_name) if animation_player.has_animation(anim_name) else null

var node_path: NodePath:
	get():
		if !animation_player: return NodePath()
		
		var root_node: Node = animation_player.get_node(animation_player.root_node)
		var node_path: NodePath = root_node.get_path_to(self)
		return NodePath(str(node_path) + ":text")

func _process(delta):
	if !animation_player: 
		return
	
	if !anim:
		anim_name = animation_player.current_animation
		if !anim: return
	
	var track_index = anim.find_track(node_path, Animation.TYPE_VALUE)
	
	if track_index == -1: 
		return
	
	var key_index = anim.track_find_key(track_index, animation_player.current_animation_position, Animation.FIND_MODE_NEAREST)
	
	if key_index == -1 || key_index + 1 >= anim.track_get_key_count(track_index): 
		visible = false
		return
	
	var key_val = anim.track_get_key_value(track_index, key_index)
	if key_val != anim.track_get_key_value(track_index, key_index + 1): 
		visible = false
		return
	
	var normalized_dialogue_position
	
	if key_index > 0 && anim.track_get_key_value(track_index, key_index - 1) == key_val:
		normalized_dialogue_position = 1
	else:
		var dialogue_start = anim.track_get_key_time(track_index, key_index)
		var dialogue_end = anim.track_get_key_time(track_index, key_index + 1)
		var dialogue_current_pos =  animation_player.current_animation_position - dialogue_start
		
		if dialogue_current_pos < 0: 
			visible = false
			return
		
		var dialogue_length: float = dialogue_end - dialogue_start
		normalized_dialogue_position = dialogue_current_pos / dialogue_length
		normalized_dialogue_position = normalized_dialogue_position if sign(normalized_dialogue_position) != -1 else 1.0
	
	if !visible: visible = true
	if scrolling_text.text != key_val: scrolling_text.text = key_val
	scrolling_text.visible_ratio = normalized_dialogue_position

func emit_dialogue_complete():
	on_dialogue_finished.emit()

func _on_current_animation_changed(anim_name):
	if !anim_name: return
	self.anim_name = anim_name

func set_text(text: String, speaker_name: String = ""):
	if speaker_label && speaker_control && speaker_name != "": 
		speaker_control.visible = true
		speaker_label.text = speaker_name
	else:
		if speaker_control: speaker_control.visible = false
		
	scrolling_text.set_scrolling_text(text)

func skip_to_the_end():
	scrolling_text.skip_to_the_end()
