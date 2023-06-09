extends Node

var currently_dragged_item: Node2D = null

func set_dragged_item(item):
	currently_dragged_item = item

func release_dragged_item():
	currently_dragged_item = null

func is_dragging_item() -> bool:
	return currently_dragged_item != null
