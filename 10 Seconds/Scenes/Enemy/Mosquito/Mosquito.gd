extends KinematicBody2D

var movedir = Vector2()
var speed = 250
var state
var up = -1
var down = 1
var direction = up
var health = 3
const MAX_HEALTH = 3
const DAMAGE = 1
var harmful = true
enum states{IDLE, STUN, DIE}

func _channge_state(new_state):
	match new_state:
		IDLE:
			set_physics_process(true)
			harmful = true
			direction = direction
		STUN:
			$FlyTimer.stop()
			set_physics_process(false)
			$AnimationPlayer.play("Stun")
			harmful = false
	state = new_state

func _ready():
	$FlyTimer.start()
	health = MAX_HEALTH

func _physics_process(delta):
	movedir.y = direction * speed
	movedir.x = 0
	movedir = move_and_slide(movedir)

func _on_FlyTimer_timeout():
	if direction == up:
		direction = down
	elif direction == down:
		direction = up
		
func damage(DAMAGE):
	health -= DAMAGE
	_channge_state(STUN)
	if health == 0:
		die()

func die():
	queue_free()

func _on_HitBox_area_entered(area):
	if area.is_in_group("Player") and harmful:
		area.get_parent().damage(DAMAGE)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Stun":
		_channge_state(IDLE)
		$FlyTimer.start()
