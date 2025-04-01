extends Control

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelSelect)
