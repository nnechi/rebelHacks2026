extends Control

var card_names = []
var card_values = []
var card_images = {}

var playerScore = 0
var dealerScore = 0
var playerCards = []
var dealerCards = []

var full52 = {}
var cardsShuffled = {}

var autoplayModifier = 1

var ace_found
var lastBet := Global.bet

@onready var graph_holder = $LeftMenuBar/Graphs/TopGraph/Panel4
var graph_scene := preload("res://graph/plot_graph.tscn")
var graph: Control

	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#take bet
	Global.push_bank_point(Global.bank)
	
	Global.bank -= Global.bet
	if Global.bank < 0:
		#ENDGAME SCENE HERE
		print("GAME OVER MAN")
		return
		
	$Background/betLabel.text = "Current bet:\n\n$" + str(Global.bet)
	$BankBalance/BalanceValue.update_bank_text()
	Dialogue.Initialize()
	
	Dialogue.ShowMessage(get_random_index(Global.welcome), true)
	
	var graph = graph_scene.instantiate()
	graph_holder.add_child(graph)	
	#call randoizer for card shuffle()
	randomize()
	if Global.autoplay_active:
		autoplayModifier = 0.1
		$Buttons/VBoxContainer/Autoplay.text = "Stop"
	else:
		autoplayModifier = 1.0
		$Buttons/VBoxContainer/Autoplay.text = "Autoplay"
	$Replay.visible = false
	$WinnerText.visible = false
	$PlayerHitMarker.visible = false
	$DealerHitMarker.visible = false
	get_tree().root.content_scale_factor
	# Create cards
	updateText()
	create_card_data()

	# Generate initial 2 player cards
	await get_tree().create_timer(0.7 * autoplayModifier).timeout
	generate_card("player")
	updateText()
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	generate_card("player")
	updateText()

	# Generate dealers cards; note how first one is true as we want to show the back
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	generate_card("dealer", true)
	updateText()
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	generate_card("dealer")
	updateText()
	await get_tree().create_timer(1 * autoplayModifier).timeout
	
	
	if playerScore == 21:
		playerWin(true)
	##21 push logic, may not be needed
	#var tempScore: int = dealerScore + dealerCards[0][0]
	#if playerScore == 21 and not tempScore == 21:
	#	playerWin(true)
	#if playerScore == 21 and  tempScore == 21:
	#	playerDraw()
	if Global.autoplay_active:
		_run_autoplay()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_random_index(array) -> String:
	# Get a random integer between 0 and my_array.size() - 1
	var random_index: int = randi() % (array.size()-1)
	return array[random_index]

func make_wrapped_card(texture_path: String) -> Control:
	var tex: Texture2D = load(texture_path)

	var wrapper := Control.new()
	wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	wrapper.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	wrapper.custom_minimum_size = tex.get_size()

	var shadow := ColorRect.new()
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.color = Color(0, 0, 0, 0.45)
	shadow.custom_minimum_size = tex.get_size()
	wrapper.add_child(shadow)

	var rect := TextureRect.new()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.texture = tex
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP
	wrapper.add_child(rect)

	shadow.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)

	shadow.position = Vector2(16, 18)
	rect.position = Vector2(0, -40)

	# --- random rotation (degrees -> radians) ---
	var deg := randf_range(-3.0, 3.0)
	rect.rotation = deg_to_rad(deg)
	shadow.rotation = rect.rotation # optional, looks nicer
	# ------------------------------------------

	rect.modulate.a = 0.0
	rect.scale = Vector2(0.9, 0.9)

	var tween := create_tween()
	tween.tween_property(rect, "position", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(rect, "modulate:a", 1.0, 0.18)
	tween.parallel().tween_property(rect, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	return wrapper

func _on_hit_pressed():
	$PlayerHitMarker.visible = true
	generate_card("player")
	# Play "hit!" animation
	$AnimationPlayer.play("HitAnimationP")
	updateText()
	if playerScore == 21:
		_on_stand_pressed()  # Player auto-stands on 21
	elif playerScore > 21:
		check_aces()  # Check to see if any 11-aces can convert to 1-aces
		if playerScore > 21:  # Score still surpasses 21
			playerLose()


func check_aces():
	# If player is over 21 and has any 11-aces, convert them to 1 so they stay under 21
	while playerScore > 21:
		ace_found = false
		for card_index in range(len(playerCards)):
			if playerCards[card_index][0] == 11:  # Ace with value 11
				playerCards[card_index][0] = 1  # Convert ace to 1
				ace_found = true
				break
		if not ace_found:
			break  # No more aces to convert, exit loop
		recalculate_player_score()
		updateText()


func recalculate_player_score():
	playerScore = 0
	for card in playerCards:
		playerScore += card[0]

###
func dealerHasSoftAce() -> bool:
	for card in dealerCards:
		if card[0] == 11:
			return true
	return false
#####

func _on_stand_pressed():
	# Flip dealer's first card, dealer keeps hitting until score is above 16 or player's score
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	$DealerHitMarker.visible = true
	$WhoseTurn.text = "Dealer's Turn"

	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	var dealer_hand_container = $Cards/Hands/DealerHand
	
	# Remove the first card from the container (the back of card texture)
	var child_to_remove = dealer_hand_container.get_child(0)
	if not child_to_remove:
		return
		
	child_to_remove.queue_free()  # Remove the node from the scene

	# Create a new TextureRect node for the card image
	var card = dealerCards[0]
	var wrapper := make_wrapped_card(card[1])
	dealer_hand_container.add_child(wrapper)
	dealer_hand_container.move_child(wrapper, 0)

	# Add score to dealerScore
	if card[0] == 11 and dealerScore > 10:  # Aces are 1 if score is too high for 11
		dealerScore += 1
	else:
		dealerScore += card[0]
	updateText()

	# Dealer hits until score surpasses player or 17 
	while (dealerScore < playerScore and dealerScore < 17 ) or(dealerScore <= 17 and dealerHasSoftAce()): 
		await get_tree().create_timer(1.5 * autoplayModifier).timeout
		# Play "hit!" animation for dealer
		$AnimationPlayer.play("HitAnimationD")
		generate_card("dealer")
		updateText()

	# Evaluate results
	if dealerScore > 21 or dealerScore < playerScore:  # Dealer bust or dealer less than player
		playerWin()
		
		if Global.autoplay_active and (dealerScore == 10 or dealerScore == 1 or dealerScore == 6):
			playerLose()
			
	elif playerScore < dealerScore and dealerScore <= 21:  # Dealer is between player score and 22
		playerLose()
	else:  # Tie
		playerDraw()


func create_card_data():
	# Generate card names for ranks 2 to 10
	for rank in range(2, 11):
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(str(rank) + "_" + suit)
			card_values.append(rank)

	# Generate card names for face cards (jack, queen, king, ace)
	for face_card in ["jack", "queen", "king", "ace"]:
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(face_card + "_" + suit)
			if face_card != "ace":
				card_values.append(10)
			else:
				card_values.append(11)


	# Load card values and image paths into the dictionary
	for card in range(len(card_names)):
		card_images[card_names[card]] = [card_values[card],
			"res://assets/images/cards_pixel/" + card_names[card] + ".png"]

	#add the the of card image with key "back"
	card_images["back"] = [0, "res://assets/images/cards_alternatives/card_back_pix.png"]

	full52 = card_names.duplicate()
	cardsShuffled = full52;
	#number of decks -1 for the range
	var count = 0
	while count < 7:
		cardsShuffled.append_array(full52)
		count +=1
	cardsShuffled.shuffle()


func generate_card(hand, back=false):
	# Assuming you have already loaded card images into the dictionary as shown in your code
	var random_card

	# If back is true assign card image to back
	if back:
		# We display the back of the card, but a real card needs to be pulled
		# so that it can be shown when the player Stands
		random_card = card_images["back"]
		dealerCards.append(card_images[cardsShuffled.pop_back()])
	else:
		# Get a random card
		var random_card_name = cardsShuffled.pop_back()
		random_card = card_images[random_card_name]
		# random_card is an array [card value, card image path]

	# Get a reference to the existing HBoxContainer
	var card_hand_container
	#give the dealer cheats
#	if (dealerScore == 11 or dealerScore == 10) and Global.autoplay_active:
#		dealerScore =21
#		updateText()
#		playerLose()
#		$Replay.emit_signal("pressed")
		
	if hand == "player":
		card_hand_container = $Cards/Hands/PlayerHand
		if random_card[0] == 11 and playerScore > 10:  # Aces are 1 if score is too high for 11
			playerScore += 1
		else:
			playerScore += random_card[0]
		playerCards.append(random_card)
	elif hand == "dealer":
		card_hand_container = $Cards/Hands/DealerHand
		if random_card[0] == 11 and dealerScore > 10:  # Aces are 1 if score is too high for 11
			dealerScore += 1
		else:
			dealerScore += random_card[0]
		dealerCards.append(random_card)
	else:
		return

	# Add wrapped card (so container controls wrapper, we animate the inside)
	var wrapper := make_wrapped_card(random_card[1])
	card_hand_container.add_child(wrapper)


func updateText():
	# Update the labels displayed on screen for the dealer and player scores.
	$DealerScore.text = str(dealerScore)
	$PlayerScore.text = str(playerScore)


func playerLose():
	Global.games+=1
	Global.losses+=1
	Global.lastGame = "Loss"
	# Player has lost: display red text, disable buttons, ask to play again
	Global.push_bank_point(float(Global.bank))
	$WinnerText.text = "DEALER WINS"
	$WinnerText.set("theme_override_colors/font_color", "ff5342")
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	await get_tree().create_timer(1 * autoplayModifier).timeout
	#$WinnerText.visible = true
	
	Dialogue.ShowMessage(get_random_index(Global.loss_lines), true)
	
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	if Global.autoplay_active:
		await get_tree().create_timer(1).timeout
		$Replay.emit_signal("pressed")
	else:
		$Replay.visible = true


func playerWin(blackjack=false):
	Global.games+=1
	Global.wins+=1
	Global.lastGame = "Win"
	# Player has won: display text (already set if not blackjack),
	# display buttons and ask to play again
	if blackjack:
		$WinnerText.text = "PLAYER WINS BY BLACKJACK"
		payPlayer(2.5)
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	payPlayer(2)
	await get_tree().create_timer(1 * autoplayModifier).timeout
	#$WinnerText.visible = true
	
	Dialogue.ShowMessage(get_random_index(Global.win_lines), true)
	
	Global.push_bank_point(float(Global.bank))
	
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	if Global.autoplay_active:
		$Replay.emit_signal("pressed")
	else:
		$Replay.visible = true


func playerDraw():
	Global.games+=1
	Global.ties+=1
	Global.lastGame = "Draw"
	
	Global.push_bank_point(Global.bank)
	Dialogue.ShowMessage("It looks like we both won...", true)

	payPlayer(1)
	# Nobody wins: display white text, disable buttons and ask to play again
	$WinnerText.text = "DRAW"
	$WinnerText.set("theme_override_colors/font_color", "white")
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	await get_tree().create_timer(1 * autoplayModifier).timeout
	$WinnerText.visible = true
	await get_tree().create_timer(0.5 * autoplayModifier).timeout
	if Global.autoplay_active:
		$Replay.emit_signal("pressed")
	else:
		$Replay.visible = true


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://betting-scene/betting-scene.tscn")


func _on_replay_pressed():
	get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")

func _on_button_pressed():
	_optimalMove()

func _optimalMove():
	# AI logic to determine optimal move
	if len(dealerCards) < 2:  # Player clicked button before dealer cards loaded
		return
	# dealerCards[0] is hidden; dealerCards[1] is the face-up card
	var dealerUpCard = dealerCards[1][0]
	var hasAce = playerHasAce(playerCards)

	if hasAce:
		# Handle cases when player has an ace
		if playerScore >= 19:
			_on_stand_pressed()
		elif playerScore == 18 and dealerUpCard <= 8:
			_on_stand_pressed()
		elif playerScore == 18 and dealerUpCard >= 9:
			_on_hit_pressed()
		else:
			_on_hit_pressed()
	else:
		# Handle cases when player does not have an ace
		if playerScore >= 17 and playerScore <= 20:
			_on_stand_pressed()
		elif playerScore >= 13 and playerScore <= 16:
			if dealerUpCard >= 2 and dealerUpCard <= 6:
				_on_stand_pressed()
			else:
				_on_hit_pressed()
		elif playerScore == 12:
			if dealerUpCard >= 4 and dealerUpCard <= 6:
				_on_stand_pressed()
			else:
				_on_hit_pressed()
		elif playerScore >= 4 and playerScore <= 11:
			_on_hit_pressed()
		else:
			_on_stand_pressed()

func playerHasAce(cards):
	# Check for an ace that is still counted as 11 (soft hand)
	for card in cards:
		if card[0] == 11:
			return true
	return false


# ── Autoplay ──────────────────────────────────────────────────────────────────

func _on_autoplay_pressed():
	if Global.autoplay_active:
		# Second press: stop autoplay
		Global.autoplay_active = false
		autoplayModifier = 1
		$Buttons/VBoxContainer/Autoplay.text = "Autoplay"
		return
	autoplayModifier = .1
	
	Global.autoplay_active = true
	$Buttons/VBoxContainer/Autoplay.text = "Stop"
	_run_autoplay()

func payPlayer(odds):
	var payment: int = floor(lastBet * odds)
	Global.bank += payment
	$BankBalance/BalanceValue.update_bank_text()
	$BankBalance/Arrow.updateArrow()
	return
	
func _run_autoplay():
	if $Replay.visible:
		$Replay.emit_signal("pressed")
	# Keep making optimal moves until the round ends or autoplay is cancelled.
	while Global.autoplay_active:
		autoplayModifier = .1
		# Round is over when Hit/Stand are both disabled
		if $Buttons/VBoxContainer/Hit.disabled:
			#Global.autoplay_active = false
			#$Buttons/VBoxContainer/Autoplay.text = "Autoplay"
			return
		_optimalMove()
		

		# Brief pause so the player can follow along
		await get_tree().create_timer(0.8 * autoplayModifier).timeout


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main-scene/main_scene.tscn")# Replace with function body.
