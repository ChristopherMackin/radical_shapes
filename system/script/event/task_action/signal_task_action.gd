@tool
class_name SignalTaskAction
extends TaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	var label = task.get_input("label")
	if label:
		manager.emit_event_signal(label)
	
	on_action_complete.emit(task.get_output(0))
