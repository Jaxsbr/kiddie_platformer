extends Node2D

func _ready() -> void:
	var player_spawn_pos = GameProgress.get_player_spawn_pos()
	var collected_coins = GameProgress.get_already_collected_coins()	
	
	if player_spawn_pos != Vector2.ZERO:
		var player = get_node("Player") as CharacterBody2D
		player.global_position = player_spawn_pos

	var tile_map = get_node("Map") as TileMapLayer
	if tile_map and len(collected_coins) > 0:
		for coin_pos in collected_coins:
			var tile_data = tile_map.get_cell_source_id(coin_pos)
			if tile_data != -1:
				var atlas_pos = tile_map.get_cell_atlas_coords(coin_pos)
				tile_map.set_cell(coin_pos, -1)
				GameProgress.increment_level_coins(coin_pos)
			else:
				print("⚠️ No coin found at", coin_pos, " - Skipping removal")
	
	var check_point = get_node("CheckPoint") as Node2D	
	if GameProgress.has_level_check_point_checked() and check_point and check_point.has_method("set_checked"):
		check_point.set_checked()
		var hearts = GameProgress.get_hearts()
		GameProgress.set_player_hearts(hearts)
