@tool
class_name RuleBucketFactoryMethod
extends BucketFactoryMethod

var rule: Rule

func produce(query: Dictionary):
	if !rule.check(query): return null
	
	return super.produce(query)
