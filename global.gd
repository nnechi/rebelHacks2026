extends Node

var autoplay_active: bool = false
var bank: int = 10000
var bet: int = 100
var games: int = 0
var wins: int = 0
var losses: int = 0
var ties: int = 0
var lastGame:String = "Draw"

# Dealer / Narration Arrays
var general_lines = [
	"Dealer smirks…",
	"Dealer blinking twice.",
	"Dealer needs a vacation.",
	"What’s for lunch?"
]

var loss_lines = [
	"Dealer: Oof, should’ve stayed.",
	"Dealer: BUSTED!",
	"Dealer: That one must have hurt.",
	"Dealer: The house says thanks.",
	"Dealer: Drinks on you!",
	"Dealer: Oh no! I just lost so much money! Now I can no longer feed my pet flamingo!",
	"Dealer: I won! Now I can buy TWO monkey NFTs!",
	"Dealer: I have money to spend on an Astro Citizen™ spaceship!"
]

var close_call_lines = [
	"Dealer: Maybe don’t hit on 20.",
	"Dealer: Risky business…",
	"Dealer: Vegas remembers.",
	"Dealer: That escalated quickly."
]

var win_lines = [
	"Dealer: BLACKJACK, BABY! Are you sure you can keep this up?",
	"Dealer: CHA-CHING! But luck won’t last forever…",
	"Dealer: High Roller Mode! Don’t strain yourself.",
	"Dealer: Winner Winner! Someone alert the casino…",
	"Dealer: Stack those chips… before they take them back.",
	"Dealer: Remember… luck isn’t a career plan.",
	"Dealer: Don’t let the chips stack higher than your wallet.",
	"Dealer: Vegas is fun… until it’s not.",
	"Dealer: Winning feels good… but addiction doesn’t.",
	"Dealer: Know when to walk away… seriously.",
	"Dealer: That streak won’t last forever. Play responsibly."
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
