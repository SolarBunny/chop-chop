extends TextureProgress

onready var max_health = get_parent().get_parent().get_parent().get("MAX_HEALTH")

func _ready():
	max_value = max_health
	value = max_health

func _on_Player_health_changed(health):
	value = health