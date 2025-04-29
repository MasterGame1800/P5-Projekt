extends Control

@onready var main_node = get_parent()

func _on_button_settings_pressed():
	pass

func _on_button_explanation_pressed():
	visible = false
	main_node.get_node("Legende").visible = true

func _on_button_back_pressed():
	var main_camera = main_node.get_node("MainCamera")
	var session_camera = main_node.get_node("SessionCamera")
	var current = get_viewport().get_camera_3d()
	
	if current == main_camera:
		get_tree().quit()
	else:
		NakamaManager.leave_match()
		main_node.start_camera_blend(current, main_camera)
