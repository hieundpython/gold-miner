extends Node

const rock_mass = 5
const silver_mass = 15
const gold_mass = 20
var total = 0

var time_left = 10

func _ready():
	# connect signal
	get_node("UI/Timer").timeout.connect(_on_timmer_timeout)
	update_time_left(time_left)
	
	# Init value for mass
	$Rock.mass = rock_mass
	$HeartGold.mass = gold_mass
	$HeartSilver.mass = silver_mass
	
	
	$Rock.mass_number.connect(change_mass)
	$HeartGold.mass_number.connect(change_mass)
	$HeartSilver.mass_number.connect(change_mass)
	
	$Rock.pick_up.connect(change_total)
	$HeartGold.pick_up.connect(change_total)
	$HeartSilver.pick_up.connect(change_total)
	
	
func change_mass(mass):
	$Player.update_speed(mass)

func change_total(new_total):
	total += new_total
	$UI/Total.text = "Total: " + str(total)
	
func _on_timmer_timeout():
	if time_left > 0:
		time_left -= 1
	update_time_left(time_left)
	
	if time_left == 0:
		game_over()
	
func update_time_left(new_time):
	get_node("UI/Time").text = "Time: " + str(new_time)
	
func game_over():
	set_process(false)
