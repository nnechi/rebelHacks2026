extends Control

func _ready():
	$Loser.visible_ratio = 0.0
	var tween: Tween = $Loser.create_tween()
	tween.tween_property($Loser, "visible_ratio", 1.0, 2.0).from(0.0)
	tween.tween_property($Loser, "modulate", Color.RED, 2.0)

	# var potato := $Loser/Comment1.create_tween()
	# potato.tween_property($Loser/Comment1, "rotation_degrees", -15.0, 0.5)

	# var tomato := $Loser/Comment2.create_tween()
	# tomato.tween_property($Loser/Comment2, "rotation_degrees", 15.0, 0.5)
