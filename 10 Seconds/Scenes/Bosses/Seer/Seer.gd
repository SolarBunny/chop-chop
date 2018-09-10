extends "res://General Scripts/PhysicsObject2D.gd"

enum states{IDLE, STAGE_ONE, STAGE_TWO}
var left = -1
var right = 1
var face_dir 
var dir = [left, right]
var health = 25
var speed = 150
var harmful 
var state
var jump_force = -750
var jumping 
var attack = ""

onready var player = get_node("../Player")

func _change_state(new_state):
	match new_state:
		IDLE:
			set_physics_process(false)
		STAGE_ONE:
			set_physics_process(true)
			
		STAGE_TWO:
			pass
	state = new_state

func _ready():
	#face_dir = dir[randi() % dir.size()]
	$Shoot.start()
	_change_state(IDLE)
	attack = "shoot"
	$JumpTimer.start()

func _physics_process(delta):
	
	if is_on_floor():
		movedir.x = 0
		if face_dir == right:
			$Sprite.scale.x = -5
		elif face_dir == left:
			$Sprite.scale.x = 5
			
	if not is_on_floor():
		attack = "stomp"

	if is_on_floor() and attack == "stomp":
		print("stomp")
		var shock = load("res://Scenes/Other/Reusable/ShockWave/ShockWave.tscn").instance()
		shock.position = $Sprite/shockpos.global_position
		shock.get("movedir").x = $Sprite.scale.x * 3
		add_child(shock)
		print(get_children())
		attack = "shoot"
	
	if player.position.x > position.x:
		face_dir = right
	elif player.position.x < position.x:
		face_dir = left

func damage(DAMAGE):
	health -= DAMAGE

func _on_Shoot_timeout():
	$Shoot.start()
	if state != IDLE and attack == "shoot":
		if is_on_floor():
			var bullet = load("res://Scenes/Other/Reusable/Laser/Laser.tscn").instance()
			bullet.position = $Sprite/origin.global_position
			#bullet.get_node("HitBox").add_collision_exception(self)
			get_parent().add_child(bullet)
	else:
		return

func _on_Engage_attack():
	_change_state(STAGE_ONE)

func _on_JumpTimer_timeout():
	var direction = player.global_position.x - global_position.x
	if state != IDLE:
		movedir.y = jump_force
		#movedir.x = player.global_position.x - global_position.x
		$JumpTimer.start()