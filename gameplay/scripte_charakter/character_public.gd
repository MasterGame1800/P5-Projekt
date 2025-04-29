extends Node

var character = preload("res://gameplay/scripte_charakter/player_properties.gd").new()

func public_vote():
	pass
#alle lebenden Spieler dürfen bei der Abstimmung am Tag eine Stimme abgegeben

func public_dead():
	character.dead = true
	pass
#setzt lebensstauts

func public_infected():
	var id = 09
	character.infected = true
	pass
#setzte Status der Werwolf Infektion

func public_entchanted():
	var id = 16
	character.enchanted = true
	pass
#setzt den verzauberten Status des Flötenspielers

func public_in_love():
	var id = 05
	character.in_love = true
	pass
#setzt den Status für die verliebten

func public_idol():
	character.idol = true
	pass
#setzt den status fürs idol

func public_mayor():
	character.mayor = true
	pass
#setzt den Bürgermeisterstatus

func public_sleepover():
	character.sleepover = true
	pass
#setzt den Status ob das Mädchen da ist

func public_guard():
	character.guard = true
	pass
#setzt den Schutz Status durch den Engel
