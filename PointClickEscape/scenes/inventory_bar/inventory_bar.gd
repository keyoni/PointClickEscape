extends Node2D

var items_to_add = []
var tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_to_all_items()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	var marker_pos =  self.get_node("InvTopMarker").get_global_position()
	tween = create_tween()
	tween.tween_property($InventoryHolder, "global_position",marker_pos,0.5).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished",can_add_item,4)


func _on_area_2d_mouse_exited() -> void:
	var marker_pos =  self.get_node("InvBottomMarker").get_global_position()
	tween = create_tween()
	tween.tween_property($InventoryHolder, "global_position",marker_pos,0.75).set_ease(Tween.EASE_OUT_IN)
	tween.connect("finished",can_add_item,4)

func add_item_to_inventory(item_resource: Item) -> void:
	items_to_add.append(item_resource)
	if tween != null and tween.is_running():
		pass
	else:
		can_add_item()
		
func connect_to_all_items():
	var static_items = get_tree().get_nodes_in_group("static_items")
	# Connect the 'item_clicked' signal from each static item to the '_on_item_clicked' method in this script
	for item in static_items:
		item.connect("released_pick_up",add_item_to_inventory)

func can_add_item():
	if items_to_add.size() > 0:
		var new_slot = load("res://scenes/inventory_slot/inventory_slot.tscn").instantiate()
		new_slot.item_resource = items_to_add.pop_front()
		$InventoryHolder.add_child(new_slot)
		
		var slot_size = new_slot.get_base_size()
		# TODO: var expot to slot gap
		var slot_gap  = Vector2(10, 10)    # Replace with the margin you want between slots
		var slot_index = $InventoryHolder.get_child_count() - 1
		var slot_count = $InventoryHolder.get_child_count()
		var central_marker_pos = $InvBottomMarker.global_position
		if slot_count % 2 == 0:  # Even slot count
			var slot_offset = (slot_count / 2) * (slot_size.x + slot_gap.x)
			new_slot.global_position = Vector2(central_marker_pos.x - slot_offset, central_marker_pos.y)
		else:  # Odd slot count
			var slot_offset = ((slot_count - 1) / 2) * (slot_size.x + slot_gap.x)
			new_slot.global_position = Vector2(central_marker_pos.x + slot_offset, central_marker_pos.y)
