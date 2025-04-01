extends Area2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var my_body: CharacterBody2D
@export var is_fall_off_area: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body == my_body:
		return # don't kill self
	
	if is_fall_off_area:
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
		print("Fall off world")
		return
	elif body.has_method("take_hit"):
		audio_stream_player_2d.play()	
		body.take_hit()

	var hearts = GameProgress.get_player_hearts()
	if hearts == 0:
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
		print("Died")

func _on_timer_timeout() -> void:	
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	GameProgress.reset_level_coins()
	GameProgress.reset_player_hearts()
