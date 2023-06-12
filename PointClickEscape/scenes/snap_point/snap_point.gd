extends Node2D

@export var max_items = 1

var items = []

func can_snap(item):
	return items.size() < max_items

func snap_item(item):
	if can_snap(item):
		items.append(item)
		item.set_global_position(self.get_global_position())
		item.connect("item_unsnapped", unsnap_item,4)
		#print(items)
	else:
		item.revert_to_previous_position()

func unsnap_item(item):
	#print(items)
	items.erase(item)
