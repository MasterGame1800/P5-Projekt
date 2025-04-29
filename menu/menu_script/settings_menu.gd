"""
This script extends the Control node and handles the back button press event.

Functions:
- _on_butto_back_pressed: Changes the scene to the Main Menu 3D scene.
"""

extends Control


func _on_butto_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu_scene_3d/Main_Menu_3D.tscn")
