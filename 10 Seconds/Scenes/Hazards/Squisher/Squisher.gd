extends "res://General Scripts/PhysicsObject2D.gd"

const DAMAGE = 2
var return_speed = 800

func _physics_process(delta):
	movedir.x = 0
	if is_on_floor():
		movedir.y = -return_speed
		

func _on_HitBox_area_entered(area):
	if area.get_parent().name == "Player":
		area.get_parent().damage(DAMAGE)
