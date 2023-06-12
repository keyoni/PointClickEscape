class_name Dialogue 
extends Control

@onready var content:= get_node("Content") as RichTextLabel
@onready var type_timer:= get_node("TypeTyper") as Timer
@onready var pause_timer:= get_node("PauseTimer") as Timer
@onready var voice_player := get_node("DialogueVoicePlayer") as AudioStreamPlayer

var _playing_voice := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(get_tree().create_timer(1.0).timeout)
	update_message("Hi I was generated for the dialogue system test for the godot game engine")


func update_message(message: String):
	content.bbcode_text = message
	content.visible_characters = 0 
	type_timer.start()
	
	
	

func _on_TypeTyper_timeout() -> void:
	if content.visible_characters < content.text.length():
		voice_player.play(0)
		content.visible_characters += 1 
	else:
		type_timer.stop()
		
func _on_DialogueVoicePlayer_finished() -> void:
	
	if _playing_voice:
		voice_player.play(0)

