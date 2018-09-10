extends KinematicBody2D

const GRAVITY = 20.0
const FLOOR_NORMAL = Vector2(0, -1)
var move_dir = Vector2()
var left = -1
var right = 1
var face_dir 
var dir = [left, right]
var health = 2
var speed = 75
var state
enum states{NORMAL, STUN, DIE}
var anim = ""
var new_anim
var harmful 
var damage = 1


func _ready():
	face_dir = dir[randi() % dir.size()]
	_change_state(NORMAL)
	harmful = true

# state machine
func _change_state(new_state):
	new_anim = "Normal"
	match new_state:
		NORMAL:
			set_physics_process(true)
			harmful = true
			$Particles2D.emitting = false
			new_anim = "Normal"
		STUN:
			set_physics_process(false)
			$Stun.start()
			new_anim = "Stun"
			harmful = false
		DIE:
			$Sprite.hide()
			$Particles2D.emitting
			harmful = false
			$Stun.start()
	state = new_state
	if anim != new_anim:
		anim = new_anim
		$Anim.play(new_anim)

func _physics_process(delta):
	# setup
	move_dir.y += GRAVITY
	move_dir.x = face_dir * speed
	move_dir = move_and_slide(move_dir, FLOOR_NORMAL)
	
	if harmful == true:
		$Hitbox/CollisionShape2D.disabled = false
	else:
		$Hitbox/CollisionShape2D.disabled = true
	#if anim != new_anim:
		#anim = new_anim
	#$Anim.play(anim)

	# dir switch
	if is_on_wall():
		if face_dir == left:
			face_dir = right
		elif face_dir == right:
			face_dir = left
	# fear of heights
	if is_on_floor():
		if $Sprite/floor_dec.is_colliding() == false:
			if face_dir == left:
				face_dir = right
			elif face_dir == right:
				face_dir = left

	# check to see if 
	#he's dead
	if health <= 0:
		_change_state(DIE)
	
	$Sprite.scale = Vector2(face_dir * 3, 3)

# minor functions
func damage(DAMAGE):
	if state != STUN:
		health -= DAMAGE
		if health != 0:
			_change_state(STUN)

func _on_Stun_timeout():
	if state == STUN:
		_change_state(NORMAL)
	elif state == DIE:
		queue_free()
# the end!

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Player") and harmful:
		area.get_parent().damage(damage)
