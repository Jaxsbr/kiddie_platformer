extends Area2D
@onready var timer: Timer = $Timer
@onready var explode_audio: AudioStreamPlayer2D = $ExplodeAudio

var direction: Vector2 = Vector2.ZERO
var speed: float = 200

func init(move_direction: Vector2) -> void:
	direction = move_direction
	timer.start()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_timer_timeout() -> void:
	timer.stop()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy or body is LevelKey:
		body.queue_free()
		
	explode_audio.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
