extends Resource

class_name MoreInfomation

func get_fields():
	var fields = {}
	for property in get_property_list():
		if not property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue
		fields[property.name] = get(property.name)
	return fields
