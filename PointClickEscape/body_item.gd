extends RigidBody2D


var selected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($RBItemSprite.texture.get_size())
	var rectShape = RectangleShape2D.new()
	rectShape.extents = Vector2($RBItemSprite.texture.get_size())
	$RBItemShape.shape = rectShape 
	print($RBItemShape.shape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("left_mouse_click"):
		selected = true
		print("Yay!")

