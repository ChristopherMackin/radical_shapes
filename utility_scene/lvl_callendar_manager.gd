extends Node

@export var day_label: RichTextLabel

func _scene_ready():
	var day_of_the_week := 0
	if Global.blackboard.has_flag(Flag.DAY_OF_THE_WEEK):
		day_of_the_week = Global.blackboard.get_flag_value(Flag.DAY_OF_THE_WEEK)
	
	day_of_the_week += 1
	day_of_the_week %= 7
	Global.blackboard.add_flag(Flag.DAY_OF_THE_WEEK, day_of_the_week)
	
	match day_of_the_week:
		0: day_label.text = "Sunday"
		1: day_label.text = "Monday"
		2: day_label.text = "Tuesday"
		3: day_label.text = "Wednesday"
		4: day_label.text = "Thursday"
		5: day_label.text = "Friday"
		6: day_label.text = "Saturday"
