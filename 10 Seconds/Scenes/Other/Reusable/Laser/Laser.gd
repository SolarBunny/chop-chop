extends KinematicBody2D 

var damage = 1
var speed = 6

var movedir = Vector2()
onready var Player = get_node("../Player")
var direction = Vector2()

func _ready():
	direction = Player.global_position - global_position
	$Destroy.start()
	rotation = direction.angle()
	$HitBox/CollisionShape2D2.disabled = true
	$active.start()

func _physics_process(delta):
	movedir = direction.normalized() * speed
	move_and_collide(movedir)

func _on_HitBox_area_entered(area):
	if area.is_in_group("Player"):
		queue_free()
		area.get_parent().damage(damage)

func _on_Destroy_timeout():
	queue_free()

func _on_HitBox_body_entered(body):
	queue_free()

func _on_active_timeout():
	$HitBox/CollisionShape2D2.disabled = false
