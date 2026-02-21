extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://betting-scene/betting-scene.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_close_game_pressed():
	get_tree().quit()

func _ready():
	$MarginContainer/TitleText.visible_ratio = 0.0  # start hidden
	var tween: Tween = $MarginContainer/TitleText.create_tween()
	tween.tween_property($MarginContainer/TitleText, "visible_ratio", 1.0, 2.0).from(0.0)
