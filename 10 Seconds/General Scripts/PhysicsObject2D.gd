extends KinematicBody2D

const GRAV = Vector2(0, 1030)
const FLOOR_NORMAL = Vector2(0, -1)

var invincible
var movedir = Vector2()

func _physics_process(delta):
	
	movedir += GRAV * delta
	movedir = move_and_slide(movedir, FLOOR_NORMAL)
	
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()