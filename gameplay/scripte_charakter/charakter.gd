"""
This script defines various character roles and their unique abilities in the game.
Each function represents a specific role and its associated actions or properties.
"""

extends Node

"""
Represents the Switch Child role.
If it's the first night, the role performs specific actions.
"""
func switch_child(first_night):
	if first_night:
		pass
	var id = 01
	pass
#wählt ein Idol, wenn dieses stirbt, wird es zum Werwolf

"""
Represents the Switch Hound role.
Allows the player to choose their faction at the beginning.
"""
func switch_hound(first_night):
	if first_night:
		pass
	var id = 02
	pass
#darf am Anfang seine Fraktion wählen

"""
Represents the Village Sisters role.
Specific actions are performed during the first night.
"""
func village_sisters(first_night):
	if first_night:
		pass
	var id = 03
	pass

"""
Represents the Village Armor role.
Allows enchanting two players during the first night.
"""
func village_armore():
	var id = 04
	print("Armor")
	pass
#darf in der ersten Nacht zwei Spieler verzaubern

"""
Represents the Village Fremdgeherin role.
Allows the player to sleep at another player's location each night.
"""
func village_fremdgeherin():
	var id = 06
	print("Liebhaberin")
	pass
#darf jede Nacht bei einen Spieler schlafen

"""
Represents the Village Angel role.
Allows the player to protect another player.
"""
func village_angel():
	var id = 07
	print("Engel")
	pass
#darf einen Spieler schützen

"""
Represents the Village Seer role.
Allows the player to view another player's card.
"""
func village_seer():
	var id = 08
	print("Seherin")
	pass
#darf eine Karte eines Spielers sehen

"""
Represents the Werewolf Vote role.
Allows all living werewolves to vote for a victim.
"""
func werewolf_vote():
	var id = 09
	print("Werwolf")
	pass
#alle lebenden Werwölfe dürfen bei der Opferwahl stimmen

func werewolf_old_wolf():
	var id = 10
	print("Urwolf")
	pass
#Urwolf darf einen Spieler infizieren

func werewolf_big_bad_wolf():
	var id =11
	print("Großer Wolf")
	pass
#großer wolf darf zweites Opfer wählen, wenn alle Werwölfe leben
func single_white_wolf():
	var id = 12
	print("Weißer Wolf")
	pass
#darf jede zweite Nacht einen Werwolf töten

func village_witch():
	var id = 13
	print("Hexe")
	pass
#darf pro Nacht einmal heilen oder töten

func village_fox():
	var id = 14
	print("Fuchs")
	pass
#darf jede Nacht eine Person auswählen und wenn er oder die beiden sitznachbaren ein Werwolf ist erfährt er es und darf noch einmal wenn nicht wird er nur aufgerufen
func single_flute_player():
	var id = 15
	print("Flötenspieler")
	pass
#darf jede Nacht zwei Spieler verzaubern gewinnt, wen alle verzaubert, sind

func village_bear():
	var id = 17
	print("Bärenführer")
	pass
#bekommt ein Audio Hinweis wenn ein Werwolf neben ihm sitzt

func village_knight():
	var id = 18
	print("Ritter")
	pass
#bei tot wird der Werwolf im Uhrzeigersinn am nächsten zu ihm verletzt und stirbt am nächsten tag

func village_tree():
	var id = 19
	print("Baum")
	pass
#tot durch Werwölfe zwei leben andre Quellen nur ein lebe

func village_hunter():
	var id = 20
	print("Jäger")
	pass
#bei tot eine Spieler töten
