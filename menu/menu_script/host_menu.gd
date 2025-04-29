"""
This script handles the behavior of the host menu.
It provides functionality to navigate back to the main menu.

Functions:
- _on_button_back_pressed: Changes the scene to the main menu when the back button is pressed.
"""

extends Control


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu_scene_3d/Main_Menu_3D.tscn")
