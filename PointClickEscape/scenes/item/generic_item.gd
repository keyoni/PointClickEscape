extends Node2D

@export var item_resource : Item
var selected = false
var snappable = false
var savedZ;
signal released
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GenericItemSprite.texture = item_resource.texture
	var rectShape = RectangleShape2D.new()
	rectShape.extents = Vector2($GenericItemSprite.texture.get_size())
	$GenericItemSprite/GenericItemArea/GenericItemShape.shape = rectShape
	savedZ = self.z_index
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_generic_item_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("left_mouse_click") and not DragManager.is_dragging_item():
		selected = true
		DragManager.set_dragged_item(self)
		self.z_index = 20
func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected == true:
			selected = false
			DragManager.release_dragged_item()
			self.z_index = savedZ
			released.emit()


