extends Node2D

@export var player: Player
@export var map: TileMapLayer

@onready var foot = player.get_node("Origin") as Marker2D

func _physics_process(delta: float) -> void:
	if !GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.JumpBoots):
		return
		
	var pass_ledge = Input.is_action_pressed("duck")
	if !pass_ledge:
		return
	
	var player_pos_in_map = map.to_local(foot.global_position)
	var player_tile_pos = map.local_to_map(player_pos_in_map)
	var tile_pos = get_bottom_tile(player_tile_pos)
	var tile_id = map.get_cell_source_id(tile_pos)
	var atlas_coords = map.get_cell_atlas_coords(tile_pos)
	var tile_data = map.get_cell_tile_data(tile_pos)
	if (tile_data and tile_data.has_custom_data("pass_ledge") and 
	tile_data.get_custom_data("pass_ledge") and pass_ledge):
		map.set_cell(tile_pos, -1)
		await get_tree().create_timer(0.2).timeout
		map.set_cell(tile_pos, tile_id, atlas_coords)

func get_bottom_tile(player_tile_pos: Vector2i) -> Vector2i:
	var down_tile = Vector2i(0, 1)
	var tile_pos = player_tile_pos + down_tile
	return tile_pos
