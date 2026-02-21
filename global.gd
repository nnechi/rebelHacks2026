extends Node

var autoplay_active: bool = false
var bank: int = 10000
var bet: int = 100
var games: int = 0
var wins: int = 0
var losses: int = 0
var ties: int = 0
var lastGame:String = "Draw"
signal bank_changed(new_bank: float)
var bank_history: Array[float] = []

var welcome = [
	"Everyone's a winner in Vegas.",
	"Sin City welcomes you!",
	"Whatever happens in Vegas, stays in Vegas."
]


# Dealer / Narration Arrays
var general_lines = [
	"*Dealer smirks*",
	"*Dealer blinks twice.*",
	"I needs a vacation...",
	"What's for lunch?"
]
var welcome = [
	"Everyone's a winner in Vegas, eventually...",
	"Enjoy your stay!",
	"Another sucker.... I mean patron.",
	"May lady luck be on your side.",
	"Fortune favors the bold."
]

var loss_lines = [
	"Better luck next time!",
	"Oof, should've stayed.",
	"BUSTED!",
	"That one must have hurt.",
	"The house says thanks."
]

var close_call_lines = [
	"Maybe don't hit on 20.",
	"Risky business…",
	"Vegas remembers.",
	"That escalated quickly."
]

var win_lines = [
	"CHA-CHING! But luck won't last forever…",
	"High Roller Mode! Don't strain yourself.",
	"Winner Winner! Someone alert the pitboss…",
	"Stack those chips… before they take them back.",
	"Remember… luck isn't a career plan.",
	"Don't let the chips stack higher than your wallet.",
	"Vegas is fun… until it's not.",
	"Winning feels good… but addiction doesn't.",
	"Know when to walk away… seriously.",
	"That streak won't last forever. Play responsibly."
]

func test() -> void:
	print("hi")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func push_bank_point(v: float) -> void:
	bank = v
	bank_history.append(v)
	if bank_history.size() > 120:
		bank_history.pop_front()
	emit_signal("bank_changed", bank)





	
	
