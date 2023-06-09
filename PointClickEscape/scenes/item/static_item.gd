extends Node2D

@export var item_resource : Item
@export_enum("PickUp", "None") var ItemState: String

var selected = false
var snappable = false
var savedZ;
signal released_pick_up(resource)
signal released_none
var savedParent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticItemSprite.texture = item_resource.texture
	var rectShape = RectangleShape2D.new()
	rectShape.extents = Vector2($StaticItemSprite.texture.get_size())
	$StaticItemSprite/StaticItemArea/StaticItemShape.shape = rectShape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_static_item_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_released("left_mouse_click") and selected == false:
		selected = true
		# I realise that I can get rid of this match/switch statement, but I'm keeping it case we want to do more stuff depending on the items :)
		match ItemState:
			"PickUp":
				released_pick_up.emit(item_resource)
				# Maybe a cool fade or something then delete
				await get_tree().create_timer(0.2).timeout
				queue_free()
			"None":
				released_none.emit()
			_:
				print("Oh snap! It's a somthing broke!")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected == true:
			selected = false
