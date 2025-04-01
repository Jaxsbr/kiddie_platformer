extends Control


func _on_exit_pressed() -> void:
	SceneTransition.exit_game()


func _on_shop_pressed() -> void:
	# Forfeit current level coins (early exit)
	GameProgress.reset_level_coins()
	SceneTransition.un_pause()
	SceneTransition.change_scene(GlobalTypes.GameStates.Shop)	


func _on_continue_pressed() -> void:
	SceneTransition.un_pause()
