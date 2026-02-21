extends Label

func _ready():
	update_bank_text()

func update_bank_text():
	# Convert the integer Global.bank to a string for the text property
	text = "$" + str(Global.bank)

#func increment_bank(value: int):
 #   Global.bank += value
 #   update_bank_text()
