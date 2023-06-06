extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	$BackpackSlots/AnimationPlayer.play("new_animation")
	


func _on_area_2d_mouse_exited() -> void:
	$BackpackSlots/AnimationPlayer.play_backwards("new_animation")
