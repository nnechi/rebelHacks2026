extends Node2D

var bet = 0.00
var input = 0 

@onready var bet_spinbox: SpinBox = $BetSpinBox
@onready var spin_edit: LineEdit = $BetSpinBox.get_line_edit()

func _ready() -> void: 
	$betLabel.text = "Current bet: " + str(bet)
	$hiddenLabel.visible = false 
	spin_edit.add_theme_font_size_override("font_size", 32)

	# change font (use your actual path)
	var f: FontFile = load("res://assets/PublicPixel.ttf")
	spin_edit.add_theme_font_override("font", f)
	
func _on_button_pressed() -> void:
	
	if (bet > 5):
		get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")
	else: 
		$hiddenLabel.visible = true
		


func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main-scene/main_scene.tscn")


func _on_auto_pressed() -> void:
	randomize()
	bet = randf_range(10, 100)
	bet_spinbox.value = bet; 

func _on_bet_spin_box_value_changed(value: float) -> void:
	bet = value

	# show warning but DON'T loop
	if bet > 0 and bet < 5.0:
		$hiddenLabel.visible = true
	else:
		$hiddenLabel.visible = false

	# don't fight the user's typing constantly; format when they finish editing
	$betLabel.text = "Current bet: $" + "%.2f" % bet
	
	
	
