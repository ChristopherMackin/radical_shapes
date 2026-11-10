@tool
class_name IntMatchBucketFactoryMethod
extends FactoryMethod

var default_product
var products: Array
var flag: Flag.Flag

func produce(query: Dictionary):
	var val := 0
	if query.has(Flag.name(flag)):
		val = query.get(Flag.name(flag))
	
	if val < 0 || val >= products.size():
		return default_product
	
	return products[val]
