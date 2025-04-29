extends Node
@export var vote_menu : Control
var Player_cards = preload("res://menu/menu_script/cards.gd").new()

func reset_votes(player_list):
	for player in player_list.size():
		player_list[player].voting_num = 0.0
	return player_list
		


func switch_child(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	
	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].idol = true
	player_lists = reset_votes(player_lists)
	return player_lists
#wählt ein Idol, wenn dieses stirbt, wird es zum Werwolf

func switch_hound(player_list, my_data):
	var num = 0
	for player in player_list:
		if player.character_id == 02:
			player_list[num].character_id = 09
			num += 1
	return player_list
#darf am Anfang seine Fraktion wählen

func village_armore(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			player_lists[player].in_love = true
	player_lists = reset_votes(player_lists)

	return player_lists
#darf in der ersten Nacht zwei Spieler verzaubern

func village_fremdgeherin(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = 0
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].sleepover = true
	player_lists = reset_votes(player_lists)
	return player_lists
#darf jede Nacht bei einen Spieler schlafen

func village_angel(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].guard = true
	player_lists = reset_votes(player_lists)
	return player_lists
#darf einen Spieler schützen

func village_seer(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
		
	Player_cards.flip(player_with_highest)
	await get_tree().create_timer(10).timeout 
	Player_cards.flip(player_with_highest)
#darf eine Karte eines Spielers sehen

func werewolfs(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 180)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
#alle lebenden Werwölfe dürfen bei der Opferwahl stimmen

func werewolf_old_wolf(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].infected = true
	player_lists = reset_votes(player_lists)
	return player_lists
#Urwolf darf einen Spieler infizieren

func werewolf_big_bad_wolf(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	
	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
#großer wolf darf zweites Opfer wählen, wenn alle Werwölfe leben

func single_white_wolf(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
#darf jede zweite Nacht einen Werwolf töten

func village_witch(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	vote_menu.start_voting(player_list, my_data.mayor, 60)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
#darf pro Nacht einmal heilen oder töten


func single_flute_player(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			player_lists[player].enchanted = true
	player_lists = reset_votes(player_lists)
	return player_lists
#darf jede Nacht zwei Spieler verzaubern gewinnt, wen alle verzaubert, sind

func village_hunter(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 60)
	
	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
#bei tot eine Spieler töten
	
func mayor(player_list, my_data):
	var player_lists = player_list
	var voten = true
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	for player in player_list:
		if player.mayor and player.dead:
			voten = false
	
	if voten:
		
		player_lists = vote_menu.start_voting(player_list, my_data.mayor, 300)
		
		for player in player_lists.size:
			if player_lists[player].voting_num != 0:
				if player_lists[player].voting_num > highest_voting_num:
					highest_voting_num  = player_list[player].voting_num
					player_with_highest = player 
		player_lists[player_with_highest].mayor = true
		player_lists = reset_votes(player_lists)
	return player_lists

func voting(player_list, my_data):
	var player_lists = player_list
	var voted_player = []
	var highest_voting_num = 0.0
	var player_with_highest = []
	
	player_lists = vote_menu.start_voting(player_list, my_data.mayor, 300)

	for player in player_lists.size:
		if player_lists[player].voting_num != 0:
			if player_lists[player].voting_num > highest_voting_num:
				highest_voting_num  = player_list[player].voting_num
				player_with_highest = player 
	player_lists[player_with_highest].dead = true
	player_lists = reset_votes(player_lists)
	return player_lists
