@tool
extends TaskAction

class_name SetGlobalValueTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, _manager : EventManager):
	var bb : Blackboard = Global.blackboard
	var expiration: Blackboard.ExpirationToken = task.get_input("expiration_index")
	expiration = expiration if expiration else 0
	
	bb.add_flag(task.get_input("flag_index"), str_to_var(task.get_input("value")), expiration)
	
	on_action_complete.emit(task.get_output(0))
