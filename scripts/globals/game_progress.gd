extends Node

const starting_player_hearts = 3
var _player_items = {
	GlobalTypes.PlayerItemTypes.Pickaxe: true,
	GlobalTypes.PlayerItemTypes.JumpBoots: false,
	GlobalTypes.PlayerItemTypes.Fireballs: false
}
var _player_hearts = starting_player_hearts
var _checkpoint = { }
var current_level = 0
var _total_coins = 0
var level_completions = {
	0: {
		"completed": false,
		"total_coins": 20,
		"coins": []
	},
	1: {
		"completed": false,
		"total_coins": 161,
		"coins": []
	},
	2: {
		"completed": false,
		"total_coins": 153,
		"coins": []
	},
	3: {
		"completed": false,
		"total_coins": 158,
		"coins": []
	},
}
var level_coin_count = { }
var level_coin_collected_positions = { }
var level_mined_block_positions = { }

# PLAYER
func set_player_hearts(value: int) -> void:
	_player_hearts = value

func reset_hearts() -> void:
	_checkpoint[current_level]["hearts"] = starting_player_hearts

func decrement_player_heart() -> void:
	_player_hearts -= 1
	print("Player Heart Decreased")

func get_player_hearts() -> int:
	return _player_hearts
	
func reset_player_hearts() -> void:
	_player_hearts = starting_player_hearts

func add_player_item(item_type: GlobalTypes.PlayerItemTypes) -> void:
	_player_items[item_type] = true
	print("Item ", item_type)
	
func has_player_item(item_type: GlobalTypes.PlayerItemTypes) -> bool:
	return _player_items[item_type]
	
# CHECKPOINTS
func save_checkpoint(checkpoint_pos: Vector2) -> void:
	# Overwrite previous checkpoints per level
	_checkpoint[current_level] = {
		"position": checkpoint_pos, # Where we respawn
		"coins": level_coin_collected_positions[current_level].duplicate(), # Coins already collected
		"mined_blocks": level_mined_block_positions[current_level].duplicate(),
		"hearts": _player_hearts
	}
	print("checked")

func get_hearts() -> int:
	if _checkpoint.get(current_level, null) == null:
		return starting_player_hearts # Default level spawn postion will be used
	return _checkpoint[current_level].get("hearts")

func has_level_check_point_checked() -> bool:
	return _checkpoint.get(current_level, null) != null

func get_player_spawn_pos() -> Vector2:
	if _checkpoint.get(current_level, null) == null:
		return Vector2.ZERO # Default level spawn postion will be used
	return _checkpoint[current_level].get("position")

func get_already_collected_coins() -> Array:
	if _checkpoint.get(current_level, null) == null:
		return [] # Empty list means no coins have been collected yet
	return _checkpoint[current_level].get("coins")

func get_already_mined_blocks() -> Array:
	if _checkpoint.get(current_level, null) == null:
		return [] # Empty list means no mined coins have been collected yet
	return _checkpoint[current_level].get("mined_blocks")

# LEVEL
func set_current_level(level: int) -> void:
	current_level = level
	print("Current Level Set: ", level)

func set_level_completion(level: int) -> void:
	level_completions[level] = true

# TOTAL COINS
func get_total_coins() -> int:
	return _total_coins
	
func can_deduct_total_coins(deduct_value: int) -> bool:
	if _total_coins >= deduct_value and _total_coins > 0:
		return true
	return false
	
func deduct_total_coins(deduct_value: int) -> bool:
	if can_deduct_total_coins(deduct_value):
		_total_coins -= deduct_value
		print("Total Coins Deducted By: ", deduct_value)
		return true
	print("Warning: Can't deduct ", deduct_value, " from Total Coins")
	return false
	
func increment_total_coins():
	for coin_pos in level_coin_collected_positions[current_level]:
		if !(coin_pos in level_completions[current_level]["coins"]):
			level_completions[current_level]["coins"].append(coin_pos)
			_total_coins += 1
	
	# Mark the level as completed
	level_completions[current_level]["completed"] = true

# LEVEL COINS
func _validate_level_coins() -> void:
	var lvl = level_coin_count.get(current_level, null)
	if lvl == null:
		# Configure initials level coin entry
		level_coin_count[current_level] = 0
		level_coin_collected_positions[current_level] = []
		level_mined_block_positions[current_level] = []

func increment_level_coins(coin_pos: Vector2i) -> void:
	_validate_level_coins()
	level_coin_count[current_level] += 1
	level_coin_collected_positions[current_level].append(coin_pos)
	
func mine_level_block(mined_block: Vector2i) -> void:
	level_mined_block_positions[current_level].append(mined_block)
	
func get_current_level_coins() -> int:
	_validate_level_coins()
	return level_coin_count[current_level]
	
func reset_level_coins() -> void:
	level_coin_count[current_level] = 0
	level_coin_collected_positions[current_level] = []
	level_mined_block_positions[current_level] = []
	print("Level: ", current_level, " Coins: ", level_coin_count[current_level])
