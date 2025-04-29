extends Node

var character = preload("res://gameplay/scripte_charakter/charakter.gd").new()

func start():
	var counter = 0
	while true:
		counter += 1
		nights(counter)


func nights(counter):
	
	if counter == 1:
		character.village_sisters(true)#
		character.switch_child(true)#
		character.switch_hound(true)#
		character.village_armore()
		#verliebten angucken
	if counter % 2:
		character.village_sisters(false)
	character.village_fremdgeherin()
	character.village_angel()
	character.village_seer()
	character.werewolf_vote()
	character.werewolf_old_wolf()
	character.werewolf_big_bad_wolf()
	if counter % 2:
		character.single_white_wolf()
	character.village_witch()
	character.village_fox()
	character.single_flute_player()
	#verzauberten
	day()


func day():
	#Bährenführeer links rechts nachtbaren
	#Ritter im uhrzeiger sinn der nächste
	#Jäger random kill if kill
	#verliebte einer tot
	#bekandgabe
	#zürücksetzen guard und sleepover
	pass
