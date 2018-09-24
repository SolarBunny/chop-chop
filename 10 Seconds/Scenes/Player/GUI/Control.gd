extends Control

func _physics_process(delta):
	
	if get_tree().paused == true:
		$Pause.show()
	else:
		$Pause.hide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == false:
			get_tree().paused = true
		else:
			get_tree().paused = false

func _on_Resume_pressed():
	get_tree().paused = false

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	
	if $Pause/VBoxContainer/Fullscreen.text == "Fullscreen: On":
		$Pause/VBoxContainer/Fullscreen.text = "Fullscreen: Off"
	elif $Pause/VBoxContainer/Fullscreen.text == "Fullscreen: Off":
		$Pause/VBoxContainer/Fullscreen.text = "Fullscreen: On"

func _on_Quit_pressed():
	get_tree().quit()
