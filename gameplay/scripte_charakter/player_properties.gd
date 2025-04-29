extends Node

#var character_id = character_id()
var player_id: int = 0 			#multiplayer.get_unique_id()
var dead: bool = false			#if the player is killed
var enchanted: bool = false		#if the player is enchated by the flute 
var in_love: bool = false		#if the player is in love
var idol: bool = false			#if the player is the idol
var mayor: bool = false			#if the player is the mayor
var infected: bool = false		#if the player is indected by the werewolves
var sleepover: bool = false		#if the girl sleeps by the player
var guard: bool = false			#if the player is guarded by the angle

func player_properties():
	player_id = 0
	dead = false			#max all player
	enchanted = false		#max all player
	in_love = false			#max 2 player
	idol = false			#max 1 player
	mayor= false			#max 1 player
	infected = false		#max 1 player
	sleepover = false		#max 1 player
	guard = false			#max 1 player
	

var player_numm = 8

func player_asign(player_num):
	var player_list = []
	for i in range(player_num):
		var player = player_properties().new(i)
		player_list.append(player)
	print(player_list)
