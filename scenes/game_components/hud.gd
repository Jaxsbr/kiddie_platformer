extends Control

@onready var label: Label = $VBoxContainer/HBoxCoins/Label
@onready var heart_1: TextureRect = $VBoxContainer/HBoxHearts/Heart1
@onready var heart_2: TextureRect = $VBoxContainer/HBoxHearts/Heart2
@onready var heart_3: TextureRect = $VBoxContainer/HBoxHearts/Heart3


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
