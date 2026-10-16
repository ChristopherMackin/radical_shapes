@tool
extends TaskAction

class_name SetGlobalValueTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, _manager : EventManager):
	var bb : Blackboard = Global.blackboard
	
	#TODO: Make this a searchable enumerable flag list
	bb.add_flag(task.get_input("flag_index"), str_to_var(task.get_input("value")))
	
	on_action_complete.emit(task.get_output(0))
