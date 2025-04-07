extends Node

# PLAYER
var _player_items = {
	GlobalTypes.PlayerItemTypes.Pickaxe: false,
	GlobalTypes.PlayerItemTypes.JumpBoots: false,
	GlobalTypes.PlayerItemTypes.Fireballs: false
}

const starting_player_hearts = 3
var _player_hearts = starting_player_hearts

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
	
var _checkpoint = { }
func save_checkpoint(checkpoint_pos: Vector2) -> void:
	# Overwrite previous checkpoints per level
	_checkpoint[current_level] = {
		"position": checkpoint_pos, # Where we respawn
		"coins": level_collected_coins[current_level].duplicate(), # Coins already collected
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

# CURRENT LEVEL
var current_level = 0

func set_current_level(level: int) -> void:
	current_level = level
	print("Current Level Set: ", level)

# TOTAL COINS
var _total_coins = 0

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
	
func increment_total_coins(increment_value: int):
	_total_coins += increment_value
	print("Total Coins Incremented By: ", increment_value)

# LEVEL COINS
var level_coins = { }
var level_collected_coins = { }

func _validate_level_coins() -> void:
	var lvl = level_coins.get(current_level, null)
	if lvl == null:
		# Configure initials level coin entry
		level_coins[current_level] = 0
		level_collected_coins[current_level] = []

func increment_level_coins(coin_pos: Vector2i) -> void:
	_validate_level_coins()
	level_coins[current_level] += 1
	level_collected_coins[current_level].append(coin_pos)
	
func get_current_level_coins() -> int:
	_validate_level_coins()
	return level_coins[current_level]
	
func reset_level_coins() -> void:
	level_coins[current_level] = 0
	level_collected_coins[current_level] = []
	print("Level: ", current_level, " Coins: ", level_coins[current_level])
