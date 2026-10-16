class_name SignalEventSubscriber
extends EventSubscriber

signal on_recieved_event_signal(label: String)

@export var filter: Array[String]

func emit_event_signal(label: String):
	if !filter || filter.has(label):
		on_recieved_event_signal.emit(label)
