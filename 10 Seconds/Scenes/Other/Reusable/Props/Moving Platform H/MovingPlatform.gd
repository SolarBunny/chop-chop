extends KinematicBody2D

const UP = Vector2(0, -1)
var movedir = Vector2()
var left = -1
var right = 1
var facedir
export (bool) var is_left 
var speed = 165
onready var player = get_node("../root/Player")

func _ready():
	if is_left:
		facedir = left
	else:
		facedir = right

func _physics_process(delta):
	movedir.x = facedir * speed
	movedir = move_and_slide(movedir, UP)
	movedir.y = 0

func _on_right_dec_body_entered(body):
	if body.is_in_group("Solids"):
		if facedir == left:
			facedir = right
		elif facedir == right:
			facedir = left

func _on_left_dec_body_entered(body):
	if body.is_in_group("Solids"):
		if facedir == left:
			facedir = right
		elif facedir == right:
			facedir = left
