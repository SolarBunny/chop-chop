extends "res://General Scripts/PhysicsObject2D.gd"

signal health_changed 
const SPEED = 295
const MAX_HEALTH = 6
const DAMAGE = 1
var jumpforce = -590
var anim = ""
var new_anim = "idle"
var can_attack
var attacking 
var health
var can_jump
var debug = false

func _ready():
	can_attack = true
	new_anim = "idle"
	attacking = false
	invincible = false
	health = MAX_HEALTH

func _physics_process(delta):
	controls_loop()

	if health <= 0:
		die()
	
	if not attacking:
		can_attack = true
	else:
		can_attack = false
	
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
		$Anim.play("attack")
	
	if health == 1:
		$Hit_Effect.emitting = true
	
	if anim != new_anim:
		anim = new_anim
		if not attacking:
			$Anim.play(anim)
	
func controls_loop():
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		movedir.x = SPEED
		$Sprite.scale.x = 3
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		movedir.x = -SPEED
		$Sprite.scale.x = -3
	else:
		movedir.x = 0
	
	var jumping 
	if is_on_floor():
		jumping = false
		can_jump = true
	
	if Input.is_action_just_pressed("jump") and can_jump:
		movedir.y = jumpforce
		can_jump = false
		$Jump_Sound.play()
	elif Input.is_action_just_released("jump"):
		if movedir.y < -75:
			movedir.y = movedir.y * 0.55

	if movedir.y < 0:
		jumping = true
	elif movedir.y > 0:
		jumping = false
	
	if is_on_floor():
		if movedir.x != 0:
			new_anim = "walk"
		else:
			new_anim = "idle"
	
	if movedir.y > 0 and not attacking:
		new_anim = "fall"
	if movedir.y < 0 and not attacking:
		new_anim = "jump"

func damage(damage):
	if not invincible:
		health -= damage
		$Hit_Effect.emitting = true
		emit_signal("health_changed", health)
		invincible = true
		$Invincibility.start()
		$Hurt.play()
		$shake.play("cam_shake")

func attack():
	$AttackTimer.start()
	$Sword_Swing.play()
	can_attack = false
	attacking = true

func _on_AttackTimer_timeout():
	can_attack = true
	new_anim = "idle"
	attacking = false
	$Anim.play(anim) 

func _on_Sword_body_entered(body):
	if body.is_in_group("Solids"):
		$Sprite/Sword/CollisionShape2D.disabled = true
	if body.is_in_group("Enemy") and body.get("harmful") == true:
		body.damage(DAMAGE)
		$Sword_Hit.play()

func _on_Invincibility_timeout():
	invincible = false
	if health > 1:
		$Hit_Effect.emitting = false

func die():
	get_tree().reload_current_scene()