extends Node2D

func _ready() -> void:
	var player_spawn_pos = GameProgress.get_player_spawn_pos()
	
	if player_spawn_pos != Vector2.ZERO:
		var player = get_node("Player") as CharacterBody2D
		player.global_position = player_spawn_pos

	var tile_map = get_node("Map") as TileMapLayer
	unload_collected_coins(tile_map)
	unload_mined_blocks(tile_map)
	unload_collected_level_keys()

	var check_point = get_node("CheckPoint") as Node2D	
	if GameProgress.has_level_check_point_checked() and check_point and check_point.has_method("set_checked"):
		check_point.set_checked()
		var hearts = GameProgress.get_hearts()
		GameProgress.set_player_hearts(hearts)

func unload_collected_coins(tile_map: TileMapLayer) -> void:
	var collected_coins = GameProgress.get_already_collected_coins()
	for coin_pos in collected_coins:
		var tile_data = tile_map.get_cell_source_id(coin_pos)
		if tile_data != -1:
			tile_map.set_cell(coin_pos, -1)
			GameProgress.increment_level_coins(coin_pos)
		else:
			print("⚠️ No coin found at", coin_pos, " - Skipping removal")
			
func unload_mined_blocks(tile_map: TileMapLayer) -> void:
	var mined_blocks = GameProgress.get_already_mined_blocks()
	for mined_block in mined_blocks:
		var tile_data = tile_map.get_cell_source_id(mined_block)
		if tile_data != -1:
			tile_map.set_cell(mined_block, -1)
		else:
			print("⚠️ No mined block found at", mined_block, " - Skipping removal")

func unload_collected_level_keys() -> void:
	var level_keys = GameProgress.get_already_collected_level_keys()
	var not_checked_level_key = GameProgress.get_current_level_key()
	
	for child in get_children():
		if child is LevelKey:
			if (child as LevelKey).key_type in level_keys:
				child.queue_free()
				break
