extends Area2D


var scene = preload("res://scenes/shape_puzzle/shape_puzzle.tscn")
var is_scene_on = false
var instance = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("left_mouse_click") and is_scene_on == false:
		if instance == null:
			instance = scene.instantiate()
			add_sibling(instance)
			instance.connect("closeScene",sceneClosed,2)
		else:
			toggle_sub_scene_visibility()
			is_scene_on = true

func sceneClosed():
	is_scene_on = false
	toggle_sub_scene_visibility()

func toggle_sub_scene_visibility():
	instance.visible = !instance.visible
