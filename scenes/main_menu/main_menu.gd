extends Control

@onready var sound_text: Label = $VBoxContainer/HBoxContainer/sound_text
@onready var button_off: TextureButton = $VBoxContainer/HBoxContainer/button_off
@onready var button_on: TextureButton = $VBoxContainer/HBoxContainer/button_on


func _ready() -> void:
	set_sound(false)

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelSelect)



func _on_button_off_pressed() -> void:
	set_sound(true)


func _on_button_on_pressed() -> void:
	set_sound(false)


func set_sound(is_on: bool) -> void:
	var text = "ON" if is_on else "OFF"
	sound_text.text = "Sound: " + text
	
	button_off.visible = !is_on
	button_on.visible = is_on
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !is_on)
