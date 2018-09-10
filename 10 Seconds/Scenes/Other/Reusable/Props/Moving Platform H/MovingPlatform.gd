extends KinematicBody2D

const UP = Vector2(0, -1)
var movedir = Vector2()
var left = -1
var right = 1
var facedir
export (bool) var is_left 
var speed = 200

func _ready():
	if is_left:
		facedir = left
	else:
		facedir = right

func _physics_process(delta):
	movedir.x = facedir * speed
	movedir = move_and_slide(movedir, UP)
	
	if is_on_wall():
		if facedir == right:
			facedir = left
		elif facedir == left:
			facedir = right
	