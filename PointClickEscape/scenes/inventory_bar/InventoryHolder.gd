extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	#var marker_pos =  self.get_node("../InvTopMarker").get_global_position()
	#var tween = create_tween()
	#tween.tween_property(self, "position",marker_pos,1)
	pass



func _on_area_2d_mouse_exited() -> void:
	pass
