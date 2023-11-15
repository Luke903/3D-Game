extends Node

func _ready():
	process_mode = PROCESS_MODE_ALWAYS		# global should never be paused

func _unhandled_input(event):
	if event.is_action_pressed("Menu"):	# instead of quitting, show the menu
		var menu = get_node_or_null("/root/Game/Menu")
		if menu == null:
			get_tree().quit()
		else:
			if not menu.visible:
				menu.show()
				get_tree().paused = true 	# pause the game while the menu is visible
			else:
				menu.hide()
				get_tree().paused = false
