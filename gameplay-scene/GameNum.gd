extends Label

func _ready():
	update_update_text()

func update_update_text():
	text = "Games: " + str(Global.games)
