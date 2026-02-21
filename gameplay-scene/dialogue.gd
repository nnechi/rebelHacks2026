extends Node

var personNamePath:String = "Dialogue/PersonName/Label"
var messageTextPath:String = "Dialogue/Message"
var dialogueMainPath:String = "Dialogue"
var dealerImagePath:String = "Dialogue/DealerFrame"
var ACTUALdealerImagePath:String = "Dialogue/DealerFrame/TextureRect"

var closedMouth:String = "res://assets/images/girlll2.png"
var openMouth:String = "res://assets/images/girlll3.png"

var personLabel:Label = null
var messageLabel:RichTextLabel = null
var dialogueMain:ColorRect = null
var dealerImage:ColorRect = null
var ACTUALdealerImage:TextureRect = null

var currentId:int = 0
var goalMessage:String = ""

func ShowMessage(text:String, isDealer:bool) -> void:
	if Global.autoplay_active:
		return
	
	if isDealer:
		personLabel.get_parent().visible = true
		dealerImage.visible = true
	else:
		personLabel.get_parent().visible = false
		dealerImage.visible = false
	
	goalMessage = text
	messageLabel.text = ""
	dialogueMain.visible = true

	var tween := create_tween()
	tween.tween_property(dialogueMain, "position", Vector2(407, 825), 0).set_ease(Tween.EASE_OUT)
	
	currentId+=1
	ACTUALdealerImage.texture = load(closedMouth)
	TweenMessage()
	
func TweenMessage() -> void:
	var waitObj = {
		"," = .5,
		"." = 1,
		"?" = 1,
		"!" = 1,
	}
	
	if (Global.bank <= 0):
		return
	
	var savedId:int = currentId
	for char in goalMessage:
		var waitTime = .07
		
		if currentId != savedId:
			return		
		
		if waitObj.has(char) and waitObj[char]:
			waitTime = waitObj[char]
			
		if char == " ":
			ACTUALdealerImage.texture = load(closedMouth)
		else:
			ACTUALdealerImage.texture = load(openMouth)
		
		
		if currentId != savedId:
			return
			
		messageLabel.text += char
		
		await get_tree().create_timer(waitTime).timeout

	ACTUALdealerImage.texture = load(closedMouth)
	await get_tree().create_timer(2).timeout
	
	if currentId != savedId:
		return
	
	HideMessage()
	
func HideMessage() -> void:
	#personLabel.get_parent().visible = false
	
	goalMessage = ""
	messageLabel.text = ""
	ACTUALdealerImage.texture = load(closedMouth)
	var tween := create_tween()
	tween.tween_property(dialogueMain, "position:y", dialogueMain.position.y + 800.0, .5).set_ease(Tween.EASE_OUT)

func Initialize() -> void:
	personLabel = get_tree().current_scene.get_node(personNamePath)
	messageLabel = get_tree().current_scene.get_node(messageTextPath)
	dialogueMain = get_tree().current_scene.get_node(dialogueMainPath)
	dealerImage = get_tree().current_scene.get_node(dealerImagePath)
	ACTUALdealerImage = get_tree().current_scene.get_node(ACTUALdealerImagePath)
	
	dialogueMain.visible = false
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var _DEBUG_BOOL = false
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		_DEBUG_BOOL = not _DEBUG_BOOL
		ShowMessage("Everyone is a winner in Las Vegas.",  _DEBUG_BOOL)
