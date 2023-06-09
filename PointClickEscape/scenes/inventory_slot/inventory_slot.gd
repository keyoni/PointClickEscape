extends Node2D

@export var item_resource : Item

var item_type = preload("res://scenes/item/generic_item.tscn")
var scaled
signal snapItem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slot_sprite = $Base.get_node("Slot")
	#Adds hole to base for item
	slot_sprite.texture = item_resource.texture
	slot_sprite.set_self_modulate(Color(0,0,0))
	slot_sprite_scale()
	#Addes draggable item
	var item = item_type.instantiate()
	item.item_resource = self.	item_resource
	item.snappable = true
	item.connect("released", snap_back)
	add_child(item)
	# Scales item to fit in slot
	item.get_child(0).scale = scaled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func slot_sprite_scale():
	var base_sprite = $Base
	var slot_sprite = base_sprite.get_node("Slot")

	# Get the dimensions of base_sprite and slot_sprite textures.
	var base_sprite_size = get_base_size()
	var slot_sprite_size = slot_sprite.texture.get_size()

	# Calculate the scale for the slot sprite to fit within the base sprite.
	var scale_ratio = min(base_sprite_size.x / slot_sprite_size.x, base_sprite_size.y / slot_sprite_size.y)

	# You can optionally use a margin (0.0 to 1.0) to scale the slot sprite even smaller.
	# This will create a gap between the slot sprite and the base_sprite boundaries.
	# margin example: 0.9 means 90% of the base_sprite size, leaving a gap of around 5% on each side.
	var margin = 0.9
	scale_ratio*= margin
	scaled = Vector2(scale_ratio, scale_ratio)
	# Apply the calculated scale to the slot_sprite.
	slot_sprite.scale = scaled

func snap_back():
	await get_tree().create_timer(0.2).timeout
	var item_obj = self.get_child(1)
	item_obj.set_global_position( self.get_node("Base/Slot").get_global_position())


func get_base_size():
	var base_sprite = $Base
	return base_sprite.texture.get_size()
