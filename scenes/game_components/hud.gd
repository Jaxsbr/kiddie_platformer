extends Control

@onready var label: Label = $VBoxContainer/HBoxCoins/Label
@onready var heart_1: TextureRect = $VBoxContainer/HBoxHearts/Heart1
@onready var heart_2: TextureRect = $VBoxContainer/HBoxHearts/Heart2
@onready var heart_3: TextureRect = $VBoxContainer/HBoxHearts/Heart3
@onready var jump_boots_indicator: TextureRect = $VBoxContainer/HBoxItems/JumpBootsIndicator
@onready var pick_axe_indicator: TextureRect = $VBoxContainer/HBoxItems/PickAxeIndicator
@onready var fireballs_indicator: TextureRect = $VBoxContainer/HBoxItems/FireballsIndicator


func _process(delta: float) -> void:
	label.text = "x " + str(GameProgress.get_current_level_coins())
	
	var hearts = GameProgress.get_player_hearts()
	heart_1.visible = false
	heart_2.visible = false
	heart_3.visible = false
	
	if hearts == 3:
		heart_3.visible = true
	elif hearts == 2:
		heart_2.visible = true
	else:
		heart_1.visible = true
		
	jump_boots_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.JumpBoots)
	pick_axe_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Pickaxe)
	fireballs_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Fireballs)
