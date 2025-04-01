extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneTransition.change_scene(GlobalTypes.GameStates.LevelSelect)
		GameProgress.increment_total_coins(GameProgress.get_current_level_coins())
		GameProgress.reset_level_coins()
