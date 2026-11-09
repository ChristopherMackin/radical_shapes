@tool
class_name RuleFactoryMethod
extends FactoryMethod

var product: Variant
var rule: Rule

func produce(query: Dictionary):
	return product if rule.check(query) else null
