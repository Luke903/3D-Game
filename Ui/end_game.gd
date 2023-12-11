extends Control

func _ready():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_quit_pressed():
	get_tree().quit()
