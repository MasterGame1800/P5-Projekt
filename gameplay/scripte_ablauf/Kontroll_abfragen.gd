"""
This script handles various game checks and updates, including victory conditions, player states, and special character effects.

Classes and Variables:
- Player_cards: Preloaded script for managing player cards.
- LabelVictory: Label node for displaying victory messages.
- Labeldead: Label node for displaying dead player messages.

Functions:
- enchanted(): Handles the enchanted state of players.
- in_love(): Handles the in-love state of players.
- in_love_dead(): Updates player states when in-love players die.
- sleepover_dead(): Updates player states for sleepover-related deaths.
- sleepover_reset(): Resets the sleepover state of players.
- reset_guard(): Resets the guard state of players.
- knight(): Handles the knight character's special actions.
- dead_players(): Updates and displays the list of dead players.
- victory(): Checks and displays victory conditions based on player states.
"""

extends Node

var Player_cards = preload("res://menu/menu_script/cards.gd").new()
@onready var LabelVictory = $/root/Node3D/VictoryLabel
@onready var Labeldead = $/root/Node3D/DeadLabel


func enchanted(players):
	var enchanted_names = []
	
	for player in players.size():
		if players[player].enchanted:
			enchanted_names.append(players[player])
	Player_cards.flip(enchanted_names)
	await get_tree().create_timer(10).timeout 
	Player_cards.flip(enchanted_names)

func in_love(players):
	var in_love_num = []
	
	for player in players.size():
		if players[player].in_love:
			in_love_num.append(players[player])
	Player_cards.flip(in_love_num)
	await get_tree().create_timer(10).timeout 
	Player_cards.flip(in_love_num)


func in_love_dead(players):

	for player in players:
		if player.in_love == true and player.dead == true:
			for s_player in players.size():
				if players[s_player].in_love:
					players[s_player].dead = true
	return players
	

func sleepover_dead(players):
	
	for player in players:
		if player.sleepover == true and player.dead == true:
			for s_player in players.size():
				if players[s_player].character_id == 06:
					players[s_player].dead = true
	return players
	
func sleepover_reset(players):
	
	for player in players.size():
		if players[player].sleepover:
			players[player].sleepover = false
	return players
	
func reset_guard(players):
	
	for player in players.size:
		if players[player].guard:
			players[player].guard = false
	return players


func knight(players):	
	var knight_num = 0
	var knight = false
	var found = false
	var save_sec_i = 0

	for player in players.size():
		if players[player].character_id == 18:
			knight_num = players[player].player_num
			knight = true
			found = true
		if knight:
			if players[player].character_id == 09 or players[player].character_id == 10 or players[player].character_id == 11 or players[player].character_id == 12 or players[player].infected:
				player.dead = true
				found = false
	if found:
		for s_player in players.size():
			if players[s_player].player_num > knight_num:
				if players[s_player].character_id == 09 or players[s_player].character_id == 10 or players[s_player].character_id == 11 or players[s_player].character_id == 12 or players[s_player].infected:
					if players[s_player].dead == false:
						save_sec_i = s_player
						if players[s_player].player_num > save_sec_i and players[s_player].player_num < knight_num:
							players[s_player].dead = true
	return players
	
'''
func bear_neighbars(players):
	var bear_num = 0
	var nearby_num = 0
	var first_person = false
	var sec_person = false
	var sec_player = false
	var first_bool = false
	
	for player in players:
		
		if first_bool:
			continue
		
		if player.character_id == 17:
			bear_num = player.player_num
			first_person = true
			sec_person = true
		if first_person:
			if player.dead:
				if player.character_id == 09 or player.character_id == 10 or player.character_id == 11 or player.character_id == 12 or player.infected:
					return true
	
	if sec_person:
		for s_player in players:
			if s_player.player_num > bear_num:
				if s_player.dead:
					sec_player = s_player
					#                                         Loooooooooggggggggggggggiiiiiiiiiiiiiiiikkkkkkkkkkkkkkkk
			if s_player.player_num == bear_num - 1:
				if s_player.character_id == 09 or s_player.character_id == 10 or s_player.character_id == 11 or s_player.character_id == 12 or s_player.infected:
						return true
	return false
'''

func dead_players(players, my_data):
	
	var dead_player = []
	for player in players:
		if player != my_data:
			if player.dead:
				dead_player.append(player)
				Labeldead.text = "Es sind "+ str(dead_player)+"gestorben, so wie Torben"
		else:
			pass

	Player_cards.flip(dead_player)


func victory(players):
	
	var max_size = players.size()
	var player_list = []
	var alive_num = 0
	
	for player in players:
		if player.dead == false:
			alive_num += 1
	
	for player1 in players:
		if player1.dead == false and player1.infected:
			player_list.append(player1)
	if player_list.size() >= alive_num:
		LabelVictory.text = "Die Infizierten haben gewonnen"
	
	player_list = []
	for player2 in players:
		if player2.dead == false and player2.enchanted:
			player_list.append(player2)
	if player_list.size() >= alive_num:
		LabelVictory.text = "Der Flötenspieler hat gewonnen"
	
	player_list = []
	for wolf in players:
		if wolf.dead == false and (wolf.character_id != 09 or wolf.character_id != 10 or wolf.character_id != 11 or wolf.character_id != 12 or wolf.infected):
			LabelVictory.text = "Das Dorf hat gewonnen"
			
	player_list = []
	for player3 in players:
		if player3.dead == false and (player3.character_id == 09 or player3.character_id == 10 or player3.character_id == 11 or player3.character_id == 12 or player3.infected):
			player_list.append(player3)
	if player_list == []:
		LabelVictory.text = "Das Dorf hat gewonnen"
	elif player_list.size() == alive_num:
		LabelVictory.text = "Die Infizierten haben gewonnen"
	for player_w in player_list:
		if player_list.size() == 1 and player_w.character_id == 12:
			LabelVictory.text = "Der weiße hat gewonnen"
