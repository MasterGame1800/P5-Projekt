"""
This script handles the voting process in the game. It creates buttons for players to vote, manages the voting logic, and updates player properties based on the votes.

Classes and Variables:
- button_count: Number of buttons created for voting.
- radius_x, radius_y: Coordinates for button placement in an oval shape.
- button_size: Size of the voting buttons.
- selected_button, selected_button_index: Tracks the currently selected button and its index.
- skip_button: Button to skip voting.
- voting_finished: Boolean to track if voting is completed.
- players: Array of players participating in the voting.
- mayor: Boolean indicating if the current player is the mayor.
- time: Voting duration.
- types: String for additional voting types.
- voting_timer: Timer to manage voting timeout.

Functions:
- _ready(): Initializes the voting timer and connects signals.
- start_voting(): Starts the voting process, resets variables, and creates buttons.
- create_oval_buttons(): Creates voting buttons in an oval layout.
- create_confirm_button(): Creates a confirm button for voting.
- create_skip_button(): Creates a skip button for voting.
- if_change(): Checks if the player list has changed.
- _on_button_pressed(): Handles button press events and updates player votes.
- update_local_players(): Updates the local player list.
- _on_button_hover_entered(): Handles hover enter events for buttons.
- _on_button_hover_exited(): Handles hover exit events for buttons.
- _on_confirm_pressed(): Handles the confirm button press event.
- _on_voting_timeout(): Handles voting timeout and finalizes the voting process.
"""

extends Control

var button_count: int = 0
var radius_x: float = -450.0
var radius_y: float = -250.0
var button_size: Vector2 = Vector2(85, 30)

var selected_button: Button = null
var selected_button_index: int = -1  
var skip_button: Button = null  
var voting_finished: bool = false

var players: Array = []
var mayor : bool = false
var time : int = 0
var types : String = ""

@onready var voting_timer: Timer = Timer.new()

func _ready():
	NakamaManager.updated_players_properties.connect(update_local_players(players.))
	add_child(voting_timer)
	voting_timer.one_shot = true
	voting_timer.connect("timeout", Callable(self, "_on_voting_timeout"))
	
	$VotingGUI.visible = false

func start_voting(all_players, my_mayor, voting_time):
	
	$VotingGUI.visible = true
	# Alles zurücksetzen
	voting_finished = false
	selected_button = null
	selected_button_index = -1
	button_count = 0
	players.clear()

	players = all_players
	button_count = players.size()
	mayor = my_mayor
	time = voting_time
	
	voting_timer.wait_time = time
	voting_timer.start()
	
	create_oval_buttons(button_count)
	create_confirm_button()
	create_skip_button()
	
	$VotingGUI.visible = false
	if voting_finished:
		return players

func create_oval_buttons(count: int):
	var center = get_size() / 2
	var angle_step = TAU / count

	for i in range(count):
		var button = Button.new()
		button.text = players[i].Player_name  
		button.size = button_size
		button.custom_minimum_size = button_size

		var angle = i * angle_step
		var x = center.x + radius_x * cos(angle) - button_size.x / 2
		var y = center.y + radius_y * sin(angle) - button_size.y / 2

		button.position = Vector2(x, y)

		button.set_meta("player", players[i])

		button.connect("pressed", _on_button_pressed.bind(button, i))
		button.connect("mouse_entered", _on_button_hover_entered.bind(button))
		button.connect("mouse_exited", _on_button_hover_exited.bind(button))
		add_child(button)

func create_confirm_button():
	var confirm_button = Button.new()
	confirm_button.text = "Confirm"
	confirm_button.size = Vector2(120, 50)
	confirm_button.custom_minimum_size = Vector2(120, 50)

	confirm_button.anchor_left = 1.0
	confirm_button.anchor_top = 1.0
	confirm_button.anchor_right = 1.0
	confirm_button.anchor_bottom = 1.0

	confirm_button.position = Vector2(-140, -70)

	confirm_button.connect("pressed", _on_confirm_pressed)
	add_child(confirm_button)

func create_skip_button():
	var center = get_size() / 2

	skip_button = Button.new()
	skip_button.text = "Skip Voting"
	skip_button.size = Vector2(150, 60)
	skip_button.custom_minimum_size = Vector2(150, 60)

	skip_button.position = center - skip_button.size / 2

	skip_button.connect("pressed", _on_button_pressed.bind(skip_button, -1))  # WICHTIG: Index -1
	skip_button.connect("mouse_entered", _on_button_hover_entered.bind(skip_button))
	skip_button.connect("mouse_exited", _on_button_hover_exited.bind(skip_button))

	add_child(skip_button)

func if_change(player_list_copy):
	if player_list_copy == players:
		return true
	return false

func _on_button_pressed(button: Button, index: int):
	if voting_finished:
		return 
	
	if selected_button != null:
		selected_button.modulate = Color(1, 1, 1)

	selected_button = button
	selected_button_index = index
	button.modulate = Color(0.4, 1.0, 0.4)

	if index == -1:
		print("Skip-Button gedrückt, keine Stimmen werden vergeben.")
		return
	
	var player_number = button.get_meta("player")
	var player_num = player_number.player_num
	
	var player_list_copy = players
	var data_change = false
	
	for player_use in players.size():
		if players[player_use].player_num == player_num:
			if mayor:
				players[player_use].voting_num += 1.5
			else:
				players[player_use].voting_num += 1.0
	
	NakamaManager.update_players_propertys(players[player_use].voting_num)

func update_local_players(new_players):
	players = new_players

func _on_button_hover_entered(button: Button):
	if voting_finished:
		return 
	
	if button != selected_button:
		button.modulate = Color(0.8, 0.7, 0.5)

func _on_button_hover_exited(button: Button):
	if voting_finished:
		return 
	
	if button != selected_button:
		button.modulate = Color(1, 1, 1)

func _on_confirm_pressed():
	if voting_finished:
		return 
	if selected_button:
		voting_finished = true 
		
	if selected_button:
		if selected_button_index == -1:
			print("Voting übersprungen!")
		else:
			print("Bestätigt:", selected_button.text)
	else:
		print("Keine Auswahl getroffen!")
		
func _on_voting_timeout():
	if voting_finished:
		return
	
	print("Zeit abgelaufen, Voting wird automatisch abgeschlossen.")
	voting_finished = true

	if selected_button:
		_on_confirm_pressed()
	else:
		if skip_button:
			_on_button_pressed(skip_button, -1)
		_on_confirm_pressed()
