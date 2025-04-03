extends Area2D

@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

# Check on first player intersection
var checked = false

func _on_body_entered(body: Node2D) -> void:
	if !checked and body is Player:
		set_checked()
		GameProgress.save_checkpoint(global_position)
		collect_sound.play()

func set_checked() -> void:
	checked = true
	modulate = "75757569"
