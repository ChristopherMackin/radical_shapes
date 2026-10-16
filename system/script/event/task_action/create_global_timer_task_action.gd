@tool
extends TaskAction

class_name CreateGlobalTimerTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	var seconds = task.get_input("seconds") if task.get_input("seconds") else 0
	var name = task.get_input("name") if task.get_input("name") else "global_timer"
	
	Global.create_global_timer(seconds, name)
	
	on_action_complete.emit(task.get_output(0))
