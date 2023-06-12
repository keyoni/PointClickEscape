extends Node2D

signal closeScene
@export var panels = []
@export var shapes_on_panels = []
var solution = [3,4,5,6]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.connect("pressed", check_snap_points)
	solution.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("exit"):
		closeScene.emit()
		
		#this just deletes the node and doesn't save any data about what happened in it
		#might just want to hide it instead
		#queue_free()

func check_snap_points():
	# Get all snap_point child nodes of this scene
	shapes_on_panels = []
	var snap_points = get_tree().get_nodes_in_group("snap_points").filter(func(node):
		return is_a_child_of_this_scene(node)
	)

	for snap_point in snap_points:
		for item in snap_point.items:
			# You can add any logic to process the items, e.g., print their names
			#print("Snap point: %s, Item: %s" % [snap_point.name, item.name])
			var info = item.get_info()
			#print(info)
			shapes_on_panels.append(info["number_of_sides"])
			
	print(shapes_on_panels)
	check_solution()
func is_a_child_of_this_scene(node):
	return self.is_ancestor_of(node)

func check_solution():
	if shapes_on_panels == solution:
		print("Matching!!")
	else:
		print("Please Try Again!")
