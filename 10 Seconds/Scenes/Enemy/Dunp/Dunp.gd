extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
var movedir = Vector2()
var upspeed = 400

func _ready():
	$UpTime.start()

func _physics_process(delta):
	movedir = move_and_slide(movedir, FLOOR_NORMAL)
	
func _on_UpTime_timeout():
	if is_on_ceiling():
		movedir.y = upspeed
		$Sprite.flip_v = false
	elif is_on_floor():
		movedir.y = -upspeed
		$Sprite.flip_v = true
	$UpTime.start()
