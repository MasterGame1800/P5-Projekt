"""
This script extends the Control node and manages the main menu for the game.

Variables:
- main_node: The parent node of the main menu.
- code_input: Input field for the match code.
- auth_result: Boolean indicating the authentication result.

Functions:
- _ready: Authenticates the player and prints the connection status.
- _on_button_host_pressed: Creates a new match and transitions to the session camera.
- _on_button_join_pressed: Joins an existing match using the provided match code.
"""

extends Control

@onready var main_node = get_parent().get_parent()
@onready var code_input = $Panel/VBoxContainer/CodeInput
var auth_result = false

func _ready():
	if not auth_result:
		auth_result = await NakamaManager.authenticate()
		print("The auth_result: ", auth_result)
		if auth_result:
			print("Connected to server!")
		else:
			print("Connected to server!")
	


func _on_button_host_pressed() -> void:
	print("Creating match...")
	if await NakamaManager.create_match():
		print("Match Code: %s" % NakamaManager.current_match_id.left(5))
		print("Match created!")
		main_node.start_camera_blend(main_node.get_node("MainCamera"), main_node.get_node("SessionCamera"))
	else:
		print("Failed to create match")


func _on_button_join_pressed() -> void:
	var match_code = code_input.text.strip_edges()
	if match_code.is_empty():
		return
	
	var match_id = await NakamaManager.find_match_id_by_code(match_code)
	if match_id.is_empty():
		return
	
	if await NakamaManager.join_match(match_id):
		main_node.start_camera_blend(main_node.get_node("MainCamera"), main_node.get_node("SessionCamera"))
