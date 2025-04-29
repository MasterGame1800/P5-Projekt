"""
This script extends the Control class and handles the back button functionality in the host menu.

Functions:
- _on_button_back_pressed: Changes the current scene to the Main Menu 3D scene.
"""

extends Control


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu_scene_3d/Main_Menu_3D.tscn")
