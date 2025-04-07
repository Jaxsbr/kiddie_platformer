class_name Player
extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio_player: AudioStreamPlayer2D = $JumpAudioPlayer
@onready var duck_audio_player: AudioStreamPlayer2D = $DuckAudioPlayer
@onready var explode_audio_player: AudioStreamPlayer2D = $ExplodeAudioPlayer
@onready var shoot_audio_player: AudioStreamPlayer2D = $ShootAudioPlayer
@onready var explode_timer: Timer = $ExplodeTimer
@onready var invulnerable_timer: Timer = $InvulnerableTimer
@onready var shoot_point_right: Marker2D = $ShootPointRight
@onready var shoot_point_left: Marker2D = $ShootPointLeft
@onready var fireball_cooldown_timer: Timer = $FireballCooldownTimer
@onready var pickaxe: Sprite2D = $Pickaxe


var is_ducking = false
var mine_active = false
var is_invulnerable = false
var can_double_jump: bool = false 
var fireballs_cooling_down: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# --- Reset double jump capability when on the floor ---
	else: 
		# If the player is on the floor, they regain the ability to double jump next time they are airborne
		can_double_jump = true 
	# --- (End of reset logic) ---
	
	# --- Modified Jump Handling ---
	var jump_pressed = Input.is_action_just_pressed("jump")
	
	# Handle ground jump.
	var has_jump_boots = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.JumpBoots)
	if jump_pressed and is_on_floor():
		jump_audio_player.play()
		velocity.y = JUMP_VELOCITY
		# Note: can_double_jump is already true here because of the check above
		
	# Handle double jump.	
	elif jump_pressed and not is_on_floor() and can_double_jump and has_jump_boots:
		jump_audio_player.play() # You might want a different sound effect here
		velocity.y = JUMP_VELOCITY # Or use DOUBLE_JUMP_VELOCITY if defined
		can_double_jump = false # Consume the double jump ability
	# --- (End of modified jump handling) ---
	
	if Input.is_action_just_pressed("duck") and is_on_floor():
		is_ducking = true
	if Input.is_action_just_released("duck") and is_on_floor():
		is_ducking = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	if direction == -1:
		animated_sprite_2d.flip_h = true
	
	var facing_direction = -1 if animated_sprite_2d.flip_h else 1
	
	if (Input.is_action_just_pressed("shoot") and 
		GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Fireballs) and 
		!fireballs_cooling_down):
		shoot(Vector2(facing_direction, 0))	
	
	# Animations
	if is_ducking:
		animated_sprite_2d.play("ducking")
	elif is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("jumping")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func shoot(direction: Vector2) -> void:
	const FIREBALL = preload("res://scenes/game_components/fireball.tscn")
	var fireball = FIREBALL.instantiate()
	get_parent().add_child(fireball)
	
	if direction.x == 1:
		fireball.global_position = shoot_point_right.global_position
	if direction.x == -1:
		fireball.global_position = shoot_point_left.global_position
	
	fireball.init(direction)
	
	fireballs_cooling_down = true
	fireball_cooldown_timer.start()
	
	shoot_audio_player.play()


func show_pickaxe(show: bool) -> void:
	pickaxe.visible = show
	if animated_sprite_2d.flip_h:
		pickaxe.flip_h = true 
		pickaxe.position.x = 7
	else:
		pickaxe.flip_h = false 
		pickaxe.position.x = 19


func _on_explode_zone_body_entered(body: Node2D) -> void:
	if body != CharacterBody2D:
		return # collide with other charcters only
	print("explode view collides with enemy")

	if mine_active:
		print(body)
		print(body.get_node("CollisionShape2D"))
		#body.get_node("CollisionShape2D").queue_free()


func _on_explode_timer_timeout() -> void:
	mine_active = false
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


func _on_fireball_cooldown_timer_timeout() -> void:
	fireballs_cooling_down = false
	fireball_cooldown_timer.stop()
