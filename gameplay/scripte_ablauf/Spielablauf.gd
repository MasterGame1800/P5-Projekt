"""
This script manages the overall game flow, including player properties, night and day cycles, and special character actions.

Classes and Variables:
- character: Preloaded character script.
- Kontroll: Preloaded control script for game checks.
- Player_cards: Preloaded script for managing player cards.
- first_life: Boolean to track if a player is in their first life.
- waiting_num: Counter for waiting loops.
- my_player_name: Name of the current player.
- player_list: List of all players in the game.
- player_list_copy: Copy of the player list for comparison.

Functions:
- set_cards_without_me(): Sets cards for players excluding the current player.
- effect_change(): Updates player effects based on game events.
- waiting_loop(): Implements a waiting loop for synchronization.
- property_update(): Updates player properties based on character IDs.
- get_my_data(): Retrieves the current player's data.
- start_loop(): Starts the main game loop with night and day cycles.
- nights(): Handles night-specific actions for characters.
- day(): Handles day-specific actions, including voting and resetting states.
"""

extends Node

var character = preload("res://gameplay/scripte/character.gd").new()
var Kontroll = preload("res://gameplay/scripte_ablauf/Kontroll_abfragen.gd").new()
var Player_cards = preload("res://menu/menu_script/cards.gd").new()
var first_life = true
var waiting_num = 0


var my_player_name = NakamaManager.display_names[NakamaManager.my_session_id] 
var player_list = []
var player_list_copy = player_list 

func set_cards_without_me(my_data):
	var list_without_me = []
	for player in player_list.size():
		if player_list[player] != my_data:
			list_without_me.append(player)
			
	Player_cards.get_player_list(list_without_me)



func effect_change(my_data):
	var sec_player_list_copy = player_list
	
	if player_list != player_list_copy:
		for player in player_list.size():
			if player_list[player].mayor != player_list_copy[player].mayor:# all
				sec_player_list_copy[player].mayor = player_list[player].mayor
			
			if my_data.enchanted or my_data.character_id == 15:
				if player_list[player].enchanted != player_list_copy[player].enchanted:
					if player_list[player].character_id != 15:
						sec_player_list_copy[player].enchanted = player_list[player].enchanted
		
			if my_data.in_love or my_data.character_id == 04:
				if player_list[player].in_love != player_list_copy[player].in_love:
					if player_list[player].character_id != 4:
						sec_player_list_copy[player].in_love = player_list[player].in_love
		
			if my_data.guard or my_data.character_id == 7:
				if player_list[player].guard != player_list_copy[player].guard:
					if player_list[player].character_id != 7:
						sec_player_list_copy[player].guard = player_list[player].guard
		
			if my_data.character_id == 01:
				if player_list[player].idol != player_list_copy[player].idol:
					if player_list[player].character_id != 01:
						sec_player_list_copy[player].idol = player_list[player].idol
			
			if my_data.infected or my_data.character_id == 01:
				if player_list[player].infected != player_list_copy[player].infected:
					if player_list[player].character_id != 01:
						sec_player_list_copy[player].infected = player_list[player].infected
					
		#sec_player_list_copy = set_cards_without_me(my_data)
		for index in sec_player_list_copy.size():
			if sec_player_list_copy[index].player_name == my_data.player_name:
				Player_cards.set_player_data(sec_player_list_copy[index])
	
	player_list_copy = player_list

func waiting_loop():
	waiting_num += 1
	var num = 0
	await get_tree().create_timer(randi()%5).timeout 
	
	while waiting_num != player_list.size():
		await get_tree().create_timer(1).timeout 
		num += 1
		if num >= 340:
			waiting_num = 0
			return
	
	
func property_update(players):
	for player in players:
		if player.character_id == 09:
			player.infected = true
		elif player.character_id == 16:
			player.enchanted = true
	return players

func get_my_data():
	for player in player_list:
		if player.Player_name == my_player_name:
			return player

func start_loop(list_of_players):
	
	player_list = list_of_players
	player_list = property_update(player_list)
	var counter = 1
	var my_data = get_my_data()
	for player in player_list:
		if player.Player_name == my_player_name:
			my_data.append(player)
	
	while true:
		counter += 1
		nights(counter,my_data)

func nights(counter,my_data):
	set_cards_without_me(my_data)
	
	if counter == 1:
		
		if my_data.character_id == 01 and my_data.dead == false: # child 1 Night
			player_list = character.switch_child(player_list, my_data)
		effect_change(my_data)
		waiting_loop()
		
		if my_data.character_id == 02 and my_data.dead == false: # Hound 1 Night 
			player_list = character.switch_hound(player_list, my_data)
		waiting_loop()
		
		if my_data.character_id == 04 and my_data.dead == false: # Armore 1 1 Night
			player_list = character.village_armore(player_list, my_data)
		effect_change(my_data)
		waiting_loop()
		
		Kontroll.in_love(player_list)
		waiting_loop()
		
	if my_data.character_id == 06 and my_data.dead == false: # Fremdgeherin
		player_list = character.village_fremdgeherin(player_list, my_data)
	waiting_loop()
	
	if my_data.character_id == 07 and my_data.dead == false: # Angle
		player_list = character.village_angel(player_list, my_data)
	effect_change(my_data)
	waiting_loop()
	
	if my_data.character_id == 08 and my_data.dead == false: # Seherin 
		character.village_seer(player_list, my_data)
	waiting_loop()
	
	if my_data.dead == false and (my_data.character_id == 09 or my_data.character_id == 10 or my_data.character_id == 11 or my_data.character_id == 12 or my_data.infected):
		player_list = character.werewolfs(player_list, my_data)
	waiting_loop()
	
	if counter == 1:
		if my_data.character_id == 10 and my_data.dead == false: # Werwölfe old
			player_list = character.werewolf_old_wolf(player_list, my_data)
	effect_change(my_data)
	waiting_loop()
	
	if counter == 1:
		if my_data.character_id == 11 and my_data.dead == false: # big bad
			player_list = character.werewolf_big_bad_wolf(player_list, my_data)
	waiting_loop()
	
	if counter % 2:
		if my_data.character_id == 12 and my_data.dead == false: # White wolf
			player_list = character.single_white_wolf(player_list, my_data)
	waiting_loop()
	
	if my_data.character_id == 13 and my_data.dead == false: # Witch
		player_list = character.village_witch(player_list, my_data)
	waiting_loop()
	
	if my_data.character_id == 15 and my_data.dead == false: # flute Player 
		player_list = character.single_flute_player(player_list, my_data)
	effect_change(my_data)
	waiting_loop()
	
	var encanted_player = Kontroll.encanted(player_list)
	waiting_loop()
	
	day(my_data)


func day(my_data):
	
	
	Kontroll.victory(player_list)
	
	#player_list = Kontroll.bear_neighbars(player_list)
	player_list = Kontroll.knight(player_list)
	player_list = Kontroll.reset_guard(player_list)
	player_list = Kontroll.sleepover_reset(player_list)
	effect_change(my_data)
	
	Kontroll.victory(player_list)
	
	if my_data.character_id == 20 and my_data.dead: # Hunter 
		player_list = character.village_hunter(player_list, my_data)
	waiting_loop()
	
	if my_data.character_id == 19 and my_data.dead and first_life:
		for player in player_list.size():
			if player_list[player].character_id == 19:
				player_list[player].dead = false
				first_life = false
	waiting_loop()
	
	player_list = Kontroll.sleepover_dead(player_list)
	player_list = Kontroll.in_love_dead(player_list)
	Kontroll.dead_players(player_list, my_data)
	
	player_list = character.mayor(player_list, my_data)					# Mayor Voting 
	effect_change(my_data)
	waiting_loop()
	
	player_list = character.voting(player_list, my_data)							# Normal Voting 
	waiting_loop()
	
	player_list = character.mayor(player_list, my_data)					# Mayor Voting 
	effect_change(my_data)
	waiting_loop()
	
	Kontroll.victory(player_list)
