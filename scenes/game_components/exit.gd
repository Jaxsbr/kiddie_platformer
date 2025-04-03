extends Area2D
@onready var exit_sound: AudioStreamPlayer2D = $ExitSound


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		exit_sound.play()
		await get_tree().create_timer(0.5).timeout
		SceneTransition.change_scene(GlobalTypes.GameStates.LevelSelect)
		GameProgress.increment_total_coins(GameProgress.get_current_level_coins())
		GameProgress.save_checkpoint(Vector2.ZERO)
		GameProgress.reset_level_coins()
		GameProgress.reset_hearts()
