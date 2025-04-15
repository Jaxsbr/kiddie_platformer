extends Node2D

@export var player: Player
@export var map: TileMapLayer

@onready var origin = player.get_node("Origin") as Marker2D
@onready var tile_break_sound: AudioStreamPlayer2D = $TileBreakSound


func _physics_process(delta: float) -> void:
	if !GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Pickaxe):
		return
	
	var player_pos_in_map = map.to_local(origin.global_position)
	var player_tile_pos = map.local_to_map(player_pos_in_map)
	var neighbors = get_neighbor_tiles(player_tile_pos)
	
	var can_mine = has_breakable_neighbor(neighbors)
	if player.has_method("show_pickaxe"):
		player.show_pickaxe(can_mine)
	
	var mine = Input.is_action_pressed("duck")
	if !mine:
		return

	var broken_a_tile = false
	for tile_pos in neighbors:
		var tile_data = map.get_cell_tile_data(tile_pos)
		if tile_data and tile_data.has_custom_data("breakable") and tile_data.get_custom_data("breakable"):
			map.set_cell(tile_pos, -1)
			broken_a_tile = true
			var tilemap_pos = map.local_to_map(tile_pos)
			GameProgress.mine_level_block(tile_pos)
			
	if broken_a_tile:
		tile_break_sound.play()

func has_breakable_neighbor(neighbors: Array[Vector2i]) -> bool:
	for tile_pos in neighbors:
		var tile_data = map.get_cell_tile_data(tile_pos)
		if tile_data and tile_data.has_custom_data("breakable") and tile_data.get_custom_data("breakable"):
			return true
	return false

func get_neighbor_tiles(player_tile_pos: Vector2i) -> Array[Vector2i]:
	var neighbors = [
		Vector2i(0, 1),   # Down
		Vector2i(0, -1),  # Up
		Vector2i(1, 0),   # Right
		Vector2i(-1, 0),  # Left
		Vector2i(1, 1),   # Down-right (optional)
		Vector2i(-1, 1),  # Down-left (optional)
		Vector2i(1, -1),  # Up-right (optional)
		Vector2i(-1, -1), # Up-left (optional)
	]

	var tiles: Array[Vector2i] = []
	for offset in neighbors:
		var tile_pos = player_tile_pos + offset
		tiles.append(tile_pos)
		
	return tiles
