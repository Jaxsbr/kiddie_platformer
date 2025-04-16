class_name LevelKey
extends Area2D

@export var key_type: GlobalTypes.LevelKeyTypes

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area):
	print(area.name, " entered ", name, " ", key_type)
	
	#explode_audio.play()
	GameProgress.collect_level_key(key_type)
	await get_tree().create_timer(0.2).timeout
	queue_free()
