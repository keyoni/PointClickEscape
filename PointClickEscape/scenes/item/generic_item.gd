extends Node2D

@export var item_resource : Item
@export var more_info_resource : MoreInfomation
@export var snappable = false
@export var inventoryItem = false

var selected = false
var savedZ;
var savedParent
var original_position
var snapped_to: Node = null


signal item_unsnapped(item)
signal released
signal snappedToPoint


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
			if snapped_to:
				item_unsnapped.emit(self)
				snapped_to = null
			if self.get_tree().get_root().has_node("GlobalDragLayer"):
				self.reparent(savedParent, true)
			released.emit()


func update_snapping():
	if snappable and selected == false:
		# Get overlapping Snap Points
		var snap_points = get_tree().get_nodes_in_group("snap_points")
		var closest_snap_point = null
		var min_distance = 999.999
		for snap_point in snap_points:
			var snap_detector_area = snap_point.get_node("SnapDetectorArea")
			if snap_detector_area.overlaps_area($GenericItemSprite/GenericItemArea):
				var distance = self.global_position.distance_to(snap_point.get_global_position())
				if distance < min_distance:
					min_distance = distance
					closest_snap_point = snap_point

			if closest_snap_point:
				#closest_snap_point.snapped = true
				#self.set_global_position(closest_snap_point.get_global_position())
				if closest_snap_point.can_snap(self):
					snapped_to = closest_snap_point
					closest_snap_point.snap_item(self)
				if inventoryItem:
					snappedToPoint.emit()
			else:
				# No overlapping items, only snap when dragged over snap point area
				self.set_global_position(original_position)
	else:
	# No snapping, just return to the original position
		pass
		
func revert_to_previous_position():
	self.global_position = original_position

func get_info():
	var more_info_fields = more_info_resource.get_fields()
	#Sfor field_name in more_info_fields:
		#(field_name, ":", more_info_fields[field_name])
	return more_info_fields
