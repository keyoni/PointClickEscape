extends Node2D

@export var item_resource : Item
var selected = false
@export var snappable = false
@export var inventoryItem = false
var savedZ;
signal released
signal snappedToPoint
var savedParent
var original_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GenericItemSprite.texture = item_resource.texture
	var rectShape = RectangleShape2D.new()
	rectShape.extents = Vector2($GenericItemSprite.texture.get_size())
	$GenericItemSprite/GenericItemArea/GenericItemShape.shape = rectShape
	savedZ = self.z_index
	self.connect("released",update_snapping)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_generic_item_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("left_mouse_click") and not DragManager.is_dragging_item():
		selected = true
		DragManager.set_dragged_item(self)
		self.z_index = 20
		# When clicked, change item's parent to the GlobalDragLayer node
		if get_tree().get_root().has_node("GlobalDragLayer"):
			savedParent = self.get_parent()
			self.reparent(get_node("GlobalDragLayer"), true)

func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		
			#if selected:
			#var current_position = global_position
			#var target_position = get_global_mouse_position()
			
			# Calculate the position change manually
			#var position_change = target_position - current_position
			#var move_speed = 25 * delta
			#var max_move_distance = position_change.length() * move_speed
			#position_change = position_change.normalized() * min(position_change.length(), max_move_distance)
			
			# Update the global position directly
			#global_position = current_position + position_change
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected == true:
			selected = false
			DragManager.release_dragged_item()
			original_position = self.get_global_position()
			if self.get_tree().get_root().has_node("GlobalDragLayer"):
				self.reparent(savedParent, true)
			released.emit()


func update_snapping():
	if snappable and selected == false:
		# Get overlapping Drag Items
		

		# Get overlapping Snap Points
		var snap_points = get_tree().get_nodes_in_group("snap_points")
		print(snap_points)

		var closest_snap_point = null
		var min_distance = 999.999
		print("snapping!")
		for snap_point in snap_points:
			var snap_detector_area = snap_point.get_node("SnapDetectorArea")
			if snap_detector_area.overlaps_area($GenericItemSprite/GenericItemArea):
				print(self.global_position,"and", snap_point.get_global_position())
				var distance = self.global_position.distance_to(snap_point.get_global_position())
				print(snap_point.global_position)
				print(distance)
				if distance < min_distance:
					min_distance = distance
					closest_snap_point = snap_point

			#print(closest_snap_point.global_position)
			if closest_snap_point:
				self.set_global_position(closest_snap_point.get_global_position())

				if inventoryItem:
					snappedToPoint.emit()
			else:
				# No overlapping items, only snap when dragged over snap point area
				self.set_global_position(original_position)
	else:
	# No snapping, just return to the original position
		pass

			#print("snapping!")
			#print(closest_body.global_position)
			#print(self.global_position)
			#self.set_global_position(closest_body.get_global_position()) 
			#print(self.global_position)
			#var tween = create_tween()
			#tween.tween_property(self, "global_position",closest_body.get_global_position(),0.5).set_ease(Tween.EASE_IN_OUT)
