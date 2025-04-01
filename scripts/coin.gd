extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pickup")
	GameProgress.increment_level_coins()
