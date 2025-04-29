extends Node

var character = preload("res://gameplay/scripte_charakter/player_properties.gd").new()

"""
This script manages public actions and statuses for characters in the game.
Each function sets or modifies a specific public property or action.
"""

"""
Allows all living players to cast a vote during the day.
"""
func public_vote():
	pass
#alle lebenden Spieler dürfen bei der Abstimmung am Tag eine Stimme abgegeben

"""
Sets the character's status to dead.
"""
func public_dead():
	character.dead = true
	pass
#setzt lebensstauts

"""
Sets the character's status to infected by werewolves.
"""
func public_infected():
	var id = 09
	character.infected = true
	pass
#setzte Status der Werwolf Infektion

"""
Sets the character's status to enchanted by the flute player.
"""
func public_entchanted():
	var id = 16
	character.enchanted = true
	pass
#setzt den verzauberten Status des Flötenspielers

"""
Sets the character's status to in love.
"""
func public_in_love():
	var id = 05
	character.in_love = true
	pass
#setzt den Status für die verliebten

"""
Sets the character's status to idol.
"""
func public_idol():
	character.idol = true
	pass
#setzt den status fürs idol

"""
Sets the character's status to mayor.
"""
func public_mayor():
	character.mayor = true
	pass
#setzt den Bürgermeisterstatus

"""
Sets the character's status to sleepover.
"""
func public_sleepover():
	character.sleepover = true
	pass
#setzt den Status ob das Mädchen da ist

"""
Sets the character's status to guarded by the angel.
"""
func public_guard():
	character.guard = true
	pass
#setzt den Schutz Status durch den Engel
