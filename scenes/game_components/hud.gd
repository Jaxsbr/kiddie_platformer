extends Control

@onready var label: Label = $VBoxContainer/HBoxCoins/Label
@onready var heart_1: TextureRect = $VBoxContainer/HBoxHearts/Heart1
@onready var heart_2: TextureRect = $VBoxContainer/HBoxHearts/Heart2
@onready var heart_3: TextureRect = $VBoxContainer/HBoxHearts/Heart3
@onready var jump_boots_indicator: TextureRect = $VBoxContainer/HBoxItems/JumpBootsIndicator
@onready var pick_axe_indicator: TextureRect = $VBoxContainer/HBoxItems/PickAxeIndicator
@onready var fireballs_indicator: TextureRect = $VBoxContainer/HBoxItems/FireballsIndicator
@onready var green_key: TextureRect = $VBoxContainer/HBoxHearts/GreenKey
@onready var pink_key: TextureRect = $VBoxContainer/HBoxHearts/PinkKey
@onready var orange_key: TextureRect = $VBoxContainer/HBoxHearts/OrangeKey
@onready var blue_key: TextureRect = $VBoxContainer/HBoxHearts/BlueKey

func _ready() -> void:
	green_key.visible = false
	pink_key.visible = false
	orange_key.visible = false
	blue_key.visible = false


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
		
	green_key.visible = false
	pink_key.visible = false
	orange_key.visible = false
	blue_key.visible = false
	var level_keys = GameProgress.get_already_collected_level_keys()
	var not_checked_level_key = GameProgress.get_current_level_key()
	if GlobalTypes.LevelKeyTypes.Green in level_keys or GlobalTypes.LevelKeyTypes.Green == not_checked_level_key:
		green_key.visible = true
	if GlobalTypes.LevelKeyTypes.Pink in level_keys or GlobalTypes.LevelKeyTypes.Pink == not_checked_level_key:
		pink_key.visible = true
	if GlobalTypes.LevelKeyTypes.Orange in level_keys or GlobalTypes.LevelKeyTypes.Orange == not_checked_level_key:
		orange_key.visible = true
	if GlobalTypes.LevelKeyTypes.Blue in level_keys or GlobalTypes.LevelKeyTypes.Blue == not_checked_level_key:
		blue_key.visible = true
		
	jump_boots_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.JumpBoots)
	pick_axe_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Pickaxe)
	fireballs_indicator.visible = GameProgress.has_player_item(GlobalTypes.PlayerItemTypes.Fireballs)
