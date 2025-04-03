class_name Player
extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio_player: AudioStreamPlayer2D = $JumpAudioPlayer
@onready var duck_audio_player: AudioStreamPlayer2D = $DuckAudioPlayer
@onready var explode_audio_player: AudioStreamPlayer2D = $ExplodeAudioPlayer
@onready var explode_timer: Timer = $ExplodeTimer
@onready var invulnerable_timer: Timer = $InvulnerableTimer

var is_ducking = false
var explode_active = false
var is_invulnerable = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_audio_player.play()
		velocity.y = JUMP_VELOCITY
		
	
	if Input.is_action_just_pressed("duck") and is_on_floor():
		is_ducking = true
		duck_audio_player.play()
		explode_active = false
	if Input.is_action_just_released("duck") and is_on_floor():
		is_ducking = false
		explode_audio_player.play()
		explode_timer.start()
		explode_active = true
		print("explode start")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	if direction == -1:
		animated_sprite_2d.flip_h = true
	
	# Animations
	if is_ducking:
		animated_sprite_2d.play("ducking")
	elif is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play(("jumping"))
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_explode_zone_body_entered(body: Node2D) -> void:
	if body != CharacterBody2D:
		return # collide with other charcters only
	print("explode view collides with enemy")

	if explode_active:
		print(body)
		print(body.get_node("CollisionShape2D"))
		#body.get_node("CollisionShape2D").queue_free()


func _on_explode_timer_timeout() -> void:
	explode_active = false
	print("explode over")


func take_hit() -> void:
	if is_invulnerable:
		return
		
	GameProgress.decrement_player_heart()
	print("Take hit")
	is_invulnerable = true
	animated_sprite_2d.modulate = "dd0000"
	invulnerable_timer.start()


func _on_invulnerable_timer_timeout() -> void:
	is_invulnerable = false
	animated_sprite_2d.modulate = "ffffff"
	invulnerable_timer.stop()


func _on_timer_timeout() -> void:	
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	GameProgress.reset_level_coins()
