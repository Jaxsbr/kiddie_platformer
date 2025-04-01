extends Control

@onready var total_coins: Label = $VBoxContainer/CoinDisplayHBox/TotalCoins
@onready var pickaxe_button: Button = $VBoxContainer/ItemsDisplayHBox/PickaxeVBox/PickaxeButton
@onready var jump_boots_button: Button = $VBoxContainer/ItemsDisplayHBox/JumpBootsVBox/JumpBootsButton
@onready var fireballs_button: Button = $VBoxContainer/ItemsDisplayHBox/FireballVBox/FireballsButton

var costs

func _ready() -> void:	
	costs = {
		pickaxe_button.name: 10,
		jump_boots_button.name: 5,
		fireballs_button.name: 1
	}
	_update_total_coins_text()
	_update_button_states()


func _on_level_select_pressed() -> void:
	SceneTransition.change_scene(GlobalTypes.GameStates.LevelSelect)


func _on_pickaxe_button_pressed() -> void:
	_purchase(costs.get(pickaxe_button.name, 0), GlobalTypes.PlayerItemTypes.Pickaxe)


func _on_jump_boots_button_pressed() -> void:
	_purchase(costs.get(jump_boots_button.name, 0), GlobalTypes.PlayerItemTypes.JumpBoots)


func _on_fireballs_button_pressed() -> void:
	_purchase(costs.get(fireballs_button.name, 0), GlobalTypes.PlayerItemTypes.Fireballs)


func _purchase(cost: int, item_type: GlobalTypes.PlayerItemTypes) -> void:	
	var success = GameProgress.deduct_total_coins(cost)

	if success:	
		# TODO: Add item received effect/sound/animation
		GameProgress.add_player_item(item_type)
		_update_total_coins_text()
		_update_button_states()
		print("Purchase Success: ", success)


func _update_button_states() -> void:
	for button in [pickaxe_button, jump_boots_button, fireballs_button]:
		var cost = costs.get(button.name, 0)
		if GameProgress.can_deduct_total_coins(cost):
			button.disabled = false
		else:
			button.disabled = true


func _update_total_coins_text() -> void:
	total_coins.text = "x " + str(GameProgress.get_total_coins())
