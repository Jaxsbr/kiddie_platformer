extends CanvasLayer

var current_game_state: GlobalTypes.GameStates = GlobalTypes.GameStates.MainMenu
var _is_paused = false
var _pause_instance

const main_menu_scene = "res://scenes/main_menu/main_menu.tscn"
const level_select_scene = "res://scenes/level_select/level_select.tscn"
const level_play_scene = "res://scenes/level_play/level__ID__.tscn"
const shop_scene = "res://scenes/shop/shop.tscn"
const pause_scene = "res://scenes/pause/pause.tscn"

func _input(event: InputEvent) -> void:	
	if (event.is_action_pressed("pause") and 
	!_is_paused and
	current_game_state == GlobalTypes.GameStates.LevelPlay):
		_pause()

		
func _pause() -> void:
	_is_paused = true
	_pause_instance = load(pause_scene).instantiate()
	var level_scene = get_tree().current_scene as Node2D
	level_scene.add_child(_pause_instance)
	Engine.time_scale = 0


func un_pause() -> void:
	_is_paused = false
	var level_scene = get_tree().current_scene as Node2D
	level_scene.remove_child(_pause_instance)
	Engine.time_scale = 1.0


func change_scene(state: GlobalTypes.GameStates, args = {}) -> void:
	current_game_state = state
	var next_scene_path: String = get_next_scene_path(args)
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("No valid scene found for ", str(current_game_state))
	
	
func get_next_scene_path(args = {}) -> String:
	match current_game_state:
		GlobalTypes.GameStates.MainMenu:
			return main_menu_scene
		GlobalTypes.GameStates.LevelSelect:
			return level_select_scene
		GlobalTypes.GameStates.LevelPlay:
			if "level_id" in args:
				return level_play_scene.replace("__ID__", str(args["level_id"]))
			else:
				print("Error: LevelPlay requires a 'level_id' argument")
		GlobalTypes.GameStates.Shop:
			return shop_scene
	
	print("No scene found for ", str(current_game_state))
	return ""


func exit_game() -> void:
	# TODO: Add cleanups/saving
	get_tree().quit()
