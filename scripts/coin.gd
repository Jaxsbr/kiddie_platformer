class_name Coin
extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pickup")
	
	var map = get_parent() as TileMapLayer
	if map:
		var coin_pos = position
		var tilemap_pos = map.local_to_map(coin_pos)
		GameProgress.increment_level_coins(tilemap_pos)
