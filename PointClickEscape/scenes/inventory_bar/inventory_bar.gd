extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	var marker_pos =  self.get_node("InvTopMarker").get_global_position()
	var tween = create_tween()
	tween.tween_property($InventoryHolder, "position",marker_pos,0.5).set_ease(Tween.EASE_IN_OUT)



func _on_area_2d_mouse_exited() -> void:
	var marker_pos =  self.get_node("InvBottomMarker").get_global_position()
	var tween = create_tween()
	tween.tween_property($InventoryHolder, "position",marker_pos,0.75).set_ease(Tween.EASE_OUT_IN)
