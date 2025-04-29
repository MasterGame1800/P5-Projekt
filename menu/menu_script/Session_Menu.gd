"""
This script extends the Control class and manages the session menu functionality.

Variables:
- player_count_input: Input field for the player count.
- players_label: Label displaying the list of players.
- start_button: Button to start the game.
- player_name_input: Input field for the player's name.

Functions:
- _ready: Connects signals and initializes the session menu.
- _on_users_updated: Updates the player list and enables/disables the start button.
- _on_player_name_input_text_submitted: Updates the player's display name.
- _on_start_button_pressed: Sends a signal to start the game and loads the game scene.
- load_game: Loads the game scene and sets the player count.
"""

extends Control

@onready var player_count_input = $VBoxContainer/PlayerCountContainer/PlayerCountInput
@onready var players_label = $VBoxContainer/ScrollContainer/VBoxContainer/Label
@onready var start_button = $VBoxContainer/StartButton
@onready var player_name_input = $VBoxContainer/PlayerNameContainer/PlayerNameInput


func _ready() -> void:
    NakamaManager.users_updated.connect(_on_users_updated)
    NakamaManager.start_game.connect(load_game)


func _on_users_updated(users):
	print("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	if NakamaManager.the_match.self_user.session_id == NakamaManager.current_users.values()[0].session_id:
		start_button.disabled = false
	else:
		start_button.disabled = true
	
	print("The List:", users)
	var player_list = "Users in Game: "
	for user in users:
		if user != users[0]:
			player_list += ", " + user + "\n"
		else:
			player_list += user
	player_count_input.value = len(users)
	players_label.text = player_list
	


func _on_player_name_input_text_submitted(given_name):
	var name = given_name
	if name == "":
		name = "Player%d" % NakamaManager.player_numbers.get(NakamaManager.my_session_id, 1)
	NakamaManager.update_display_name(name)


func _on_start_button_pressed():
	NakamaManager.send_data_to_match({"start_game": true}, 3)
	load_game()


func load_game():
	var game_scene = load("res://menu/menu_scene_3d/Game.tscn").instantiate()
	game_scene.get_node("Cards").player_count = player_count_input.value
	get_tree().root.add_child(game_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = game_scene
