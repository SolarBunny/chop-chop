extends Area2D

signal attack

func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("Player"):
			emit_signal("attack")