@tool
class_name BucketFactoryMethod
extends FactoryMethod

var buckets: Array

func produce(query: Dictionary):
	for bucket in buckets:
		var product = bucket.produce(query)
		if product != null:
			return product
	
	return null
