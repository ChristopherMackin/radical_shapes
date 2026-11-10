@tool
class_name FlagValueRule
extends Rule

@export var flag: Flag.Flag
@export var comparitor: EnumComparitor.Comparitor
@export var value: Variant

func check(query : Dictionary) -> bool:
	if !query.has(Flag.name(flag)):
		return value is bool && value == false
	
	return EnumComparitor.evaluate(query.get(Flag.name(flag)), value, comparitor)
