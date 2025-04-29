"""
This script manages the constant GUI elements in the game.
It handles button interactions for settings, explanations, and navigation.

Classes and Variables:
- main_node: The parent node of the GUI.

Functions:
- _on_button_settings_pressed: Placeholder for settings button functionality.
- _on_button_explanation_pressed: Navigates to the legend menu when the explanation button is pressed.
- _on_button_back_pressed: Handles back button functionality, including quitting the game or switching cameras.
"""

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
