extends Node2D

signal closeScene
@export var panels = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("exit"):
		closeScene.emit()
		#this just deletes the node and doesn't save any data about what happened in it
		#might just want to hide it instead
		queue_free()
