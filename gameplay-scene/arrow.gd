extends TextureRect


func _ready() -> void:
	updateArrow()
	
func updateArrow():
	if Global.lastGame == "Draw":
		visible = false
		return
	if Global.lastGame == "Win":
		modulate  = Color(0, 1, 0, 1) #green
		flip_v = false
		visible = true
		$Shadow.flip_v = false
	if Global.lastGame == "Loss":
		flip_v = true
		visible = true
		modulate = Color(1.0, 0.0, 0.0, 1.0) #red
		$Shadow.flip_v = true
	return
