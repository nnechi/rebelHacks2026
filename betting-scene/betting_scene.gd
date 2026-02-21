extends Node2D

#var Global.bet = 0.00
var input = Global.bet 

@onready var bet_spinbox: SpinBox = $BetSpinBox
@onready var spin_edit: LineEdit = $BetSpinBox.get_line_edit()

func _ready() -> void: 
	$betLabel.text = "Current bet: " + str(Global.bet)
	$hiddenLabel.visible = false 
	spin_edit.add_theme_font_size_override("font_size", 32)

	# change font (use your actual path)
	var f: FontFile = load("res://assets/PublicPixel.ttf")
	spin_edit.add_theme_font_override("font", f)
	
	# Flash the bet label, for that eye grabbing effect
	_flash($betLabel)
	
func _on_button_pressed() -> void:
	
	if (Global.bet > 5):
		get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")
	else: 
		$hiddenLabel.visible = true
		


func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main-scene/main_scene.tscn")


func _on_auto_pressed() -> void:
	randomize()
	Global.bet = floor(randf_range(10, 100))
	bet_spinbox.value = Global.bet; 

func _on_bet_spin_box_value_changed(value: int) -> void:
	Global.bet = value

	# show warning but DON'T loop
	if Global.bet > 0 and Global.bet < 5.0:
		$hiddenLabel.visible = true
	else:
		$hiddenLabel.visible = false

	# don't fight the user's typing constantly; format when they finish editing
	$betLabel.text = "Current bet: $" + "%.2f" % Global.bet
	
	
func _flash(node: Control, speed := 0.6) -> void:
	var tween := node.create_tween()
	tween.set_loops()  # repeat forever
	tween.tween_property(node, "modulate:a", 0.0, speed)
	tween.tween_property(node, "modulate:a", 1.0, speed)
	
	
