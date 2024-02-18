extends Area2D

const mass = 10

func _ready():
	set_process(false)

func _process(delta):
	pass



func _on_area_entered(area):
	if area.is_in_groups(""):
		
