"""
This script defines the main game loop and the sequence of events for each night and day.
It handles the actions of various characters and the progression of the game.
"""
extends Node

var character = preload("res://gameplay/scripte_charakter/charakter.gd").new()

"""
Starts the main game loop, alternating between nights and days.
"""
func start():
	var counter = 0
	while true:
		counter += 1
		nights(counter)

"""
Handles the events that occur during the night phase.

@param counter: The current night number.
"""
func nights(counter):
	if counter == 1:
		character.village_sisters(true)  # Village Sisters perform their first-night action.
		character.switch_child(true)  # Switch Child performs their first-night action.
		character.switch_hound(true)  # Switch Hound performs their first-night action.
		character.village_armore()  # Village Armor performs their action.
		# Handle actions for characters in love.
	if counter % 2:
		character.village_sisters(false)  # Village Sisters perform their regular action.
	character.village_fremdgeherin()  # Village Fremdgeherin performs their action.
	character.village_angel()  # Village Angel performs their action.
	character.village_seer()  # Village Seer performs their action.
	character.werewolf_vote()  # Werewolves vote for a victim.
	character.werewolf_old_wolf()  # Old Werewolf performs their action.
	character.werewolf_big_bad_wolf()  # Big Bad Wolf performs their action.
	if counter % 2:
		character.single_white_wolf()  # White Wolf performs their action every second night.
	character.village_witch()  # Village Witch performs their action.
	character.village_fox()  # Village Fox performs their action.
	character.single_flute_player()  # Flute Player performs their action.
	# Handle actions for enchanted characters.
	day()

"""
Handles the events that occur during the day phase.
"""
func day():
	# Handle actions for the Bear Leader's neighbors.
	# Handle actions for the Knight's next target in clockwise order.
	# Handle actions for the Hunter's random kill if killed.
	# Handle actions for characters in love if one dies.
	# Announce results.
	# Reset guard and sleepover statuses.
	pass
