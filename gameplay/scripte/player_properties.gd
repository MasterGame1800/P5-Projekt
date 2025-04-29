extends Node

class Player:
	
	var player_name: String
	var player_num: int
	var character_id: int
	var voting_num: float
	var dead: bool
	var enchanted: bool
	var in_love: bool
	var idol: bool
	var mayor: bool
	var infected: bool
	var sleepover: bool
	var guard: bool

	func _init(name: String):
		player_name = name
		player_num = 0
		character_id = 0
		voting_num = 0.0
		dead = false
		enchanted = false
		in_love = false
		idol = false
		mayor = false
		infected = false
		sleepover = false
		guard = false

func create_players(num: int) -> Array:
	var player_list = []
	var use_character = character_list(num)
	var my_num = 0
	var random_index = 0

	for i in range(num):
		random_index = randi() % use_character.size()

		var player = Player.new(NakamaManager.display_names.values()[i])
		player.player_num = i
		player.character_id = use_character.pop_at(random_index)
		player_list.append(player)
	return player_list

func character_list(num):
	var in_use_character = [04,20,08,13,06,09,09,09]
	var open_character = [15,10,14,18,11,01,07,12,02,17]#03,19
	var my_num = 0
	var random_index = 0
	var is_03 = false

	for x in range(num-8):
		if is_03:
			is_03 = false
			continue
		if open_character == []:
			open_character.append(21)
		random_index = randi() % open_character.size()
		my_num = open_character.pop_at(random_index)
		if my_num == 03:
			is_03 = true
			in_use_character.append(my_num)
		in_use_character.append(my_num)
	
	return in_use_character
	
#var spieler = create_players(5)
