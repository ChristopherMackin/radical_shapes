@tool
@abstract
class_name EventFactory
extends Resource

var method: FactoryMethod = FactoryMethod.new()

func get_event(query: Dictionary) -> Event:
	var event = method.produce(query)
	if !event: return null
	return event if !query.has(event.resource_path.get_file()) else null

func produce(query: Dictionary):
	return get_event(query)
