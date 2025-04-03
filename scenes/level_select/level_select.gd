extends Node2D

func _on_level_0_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelPlay, {"level_id": 0})
	GameProgress.set_current_level(0)

func _on_level_1_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelPlay, {"level_id": 1})
	GameProgress.set_current_level(1)

func _on_level_2_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelPlay, {"level_id": 2})
	GameProgress.set_current_level(2)

func _on_level_3_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelPlay, {"level_id": 3})
	GameProgress.set_current_level(3)

func _on_shop_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.Shop)
