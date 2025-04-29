extends Control

var All_players =  preload("res://gameplay/scripte/player_properties.gd").new()

var button_count: int = 0
var radius_x: float = -450.0
var radius_y: float = -250.0
var button_size: Vector2 = Vector2(85, 30)

var selected_button: Button = null
var selected_button_index: int = -1  
var skip_button: Button = null  
var voting_finished: bool = false

var players: Array = []
var my_player_data: Array = []
var time : int = 0
var types : String = ""

@onready var voting_timer: Timer = Timer.new()

func _ready():
	add_child(voting_timer)
	voting_timer.one_shot = true
	voting_timer.connect("timeout", Callable(self, "_on_voting_timeout"))

func start_voting(all_players, player_data, voting_time):

	# Alles zurücksetzen
	voting_finished = false
	selected_button = null
	selected_button_index = -1
	button_count = 0
	players.clear()
	my_player_data.clear()

	players = all_players
	button_count = players.size()
	my_player_data = player_data
	time = voting_time
	
	voting_timer.wait_time = time
	voting_timer.start()
	
	create_oval_buttons(button_count)
	create_confirm_button()
	create_skip_button()
	
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
	
	var player = button.get_meta("player")
	
	if player == null:
		print("Warnung: Spieler-Daten fehlen für Button!")
		return

	if player.mayor:
		player.voting_num += 1.5
	else:
		player.voting_num += 1.0

	print("Ausgewählt:", button.text, "Neue Stimmenzahl:", player.voting_num)


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
