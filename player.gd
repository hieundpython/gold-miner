extends Node

var screen_size = Vector2.ZERO
var radius = 100
var angle = 0
var angule_speed = PI/3

enum {ROTATION_RIGHT, ROTATION_LEFT, GO_UP, GO_DOWN}
var state = ROTATION_LEFT
var go_to_left = true

var middle_position = Vector2.ZERO
var anchor_position = Vector2.ZERO

var speed_pull = 3

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	middle_position = Vector2(screen_size.x / 2, 100)
	$Middle.position = middle_position
	
	anchor_position = Vector2(middle_position.x + radius, 200)
	$Anchor.position = anchor_position


func _process(delta):
	if angle >= PI:
		state = ROTATION_RIGHT
		go_to_left = false
	if angle < 0:
		state = ROTATION_LEFT
		go_to_left = true
		
	if Input.is_action_pressed("ui_down") && state != GO_DOWN && state != GO_UP:
		state = GO_DOWN
		
	change_position(delta)

	
func change_position(delta):
	var x = 0
	var y = 0
	
	if state == ROTATION_LEFT:
		angle += angule_speed * delta
	if state == ROTATION_RIGHT:
		angle -= angule_speed * delta
		
	if state in [ROTATION_LEFT, ROTATION_RIGHT]:
		x = middle_position.x + cos(angle) * radius
		y = middle_position.y + sin(angle) * radius
		
	if state == GO_DOWN:
		x = anchor_position.x + speed_pull * cos(angle)
		y = anchor_position.y + speed_pull * sin(angle)
		
	if state == GO_UP:
		x = anchor_position.x - speed_pull * cos(angle)
		y = anchor_position.y - speed_pull * sin(angle)
	
	# Detect collision
	var screen_rect = Rect2(0, 0, screen_size.x, screen_size.y)
	if !screen_rect.has_point(Vector2(x, y)):
		state = GO_UP
		
	var distance = sqrt((x - middle_position.x)*(x - middle_position.x) + (y - middle_position.y)*(y - middle_position.y))

	if state == GO_UP && (distance - radius < 0):
		if go_to_left:
			state = ROTATION_LEFT
		else:
			state = ROTATION_RIGHT
		
	anchor_position = Vector2(x, y)


	$Anchor.position = anchor_position
	$Anchor.rotation = -PI/2 + angle
	
	var x1 = anchor_position.x - 20 * cos(angle)
	var y1 = anchor_position.y - 20 * sin(angle)


	$Line2D.points = [middle_position, Vector2(x1, y1)]
	$Line2D.width = 8


func _on_anchor_area_entered(area):
	state = GO_UP


func update_speed(speed):
	speed_pull = speed
