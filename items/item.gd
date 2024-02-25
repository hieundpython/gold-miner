extends Area2D


@export var mass = 10

signal mass_number
signal pick_up

var middle_position = Vector2.ZERO;
var radius = 100

func _ready():
	set_process(false)
	area_entered.connect(_on_area_entered)
	var screen_size = get_viewport().get_visible_rect().size
	middle_position = Vector2(screen_size.x / 2, 100)

func _process(delta):
	var direction = position - middle_position
	var direction_normal = -direction.normalized()
	
	position += direction_normal * mass
	
	var distance = (position - middle_position).length()
	if distance - radius < 0:
		pick_up_item()
		queue_free()
	
func _on_area_entered(area: Area2D):
	mass_number.emit(mass)
	set_process(true)
	
	
func pick_up_item():
	pick_up.emit(mass)
