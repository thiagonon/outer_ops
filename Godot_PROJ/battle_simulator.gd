extends Control

@onready var log_label = $LogLabel
@onready var simulate_button = $SimulateButton

#Simplified combatant info
var soldier_a = {
	"name": "Foxhound Troop",
	"hp": 100,
	"attack": 25,
	"defense": 10,
	"speed": 5,
	"weapon": ".38 Snub"
}

var soldier_b = {
	"name": "Cobra Unit Troop",
	"hp": 100,
	"attack": 20,
	"defense": 15,
	"speed": 4,
	"weapon": "WPPK"
}

#Functions
func _ready():
	simulate_button.pressed.connect(_on_simulate_pressed)

func _on_simulate_pressed():
	simulate_battle()

func simulate_battle():
	log_label.clear()

	#Random number for initiative
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var initiative_a = rng.randi_range(1, 100)
	var initiative_b = rng.randi_range(1, 100)
	
	var turn = 1	
	var attacker = soldier_a if soldier_a["speed"]+initiative_a >= soldier_b["speed"]+initiative_b else soldier_b
	var defender = soldier_b if attacker == soldier_a else soldier_a

	while soldier_a["hp"] > 0 and soldier_b["hp"] > 0:
		log_label.append_text("[b]Turn %d:[/b]\n" % turn)

		var damage = max(1, attacker["attack"] - defender["defense"] + randi_range(-2, 2))
		defender["hp"] -= damage
		log_label.append_text("%s hits %s with %s for %d damage!\n" % [attacker["name"], defender["name"], 
		attacker["weapon"], damage])
		log_label.append_text("%s HP: %d\n\n" % [defender["name"], max(0, defender["hp"])])

		if defender["hp"] <= 0:
			log_label.append_text("[color=green]%s wins![/color]\n" % attacker["name"])
			break

		var temp = attacker
		attacker = defender
		defender = temp
		turn += 1
