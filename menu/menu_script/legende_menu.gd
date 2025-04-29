extends Control

@onready var bewohner = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerBewohner.get_children()
@onready var werwölfe = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerWerwolf.get_children()
@onready var solo = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerSolo.get_children()
@onready var switch = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerSwitch.get_children()
@onready var items = bewohner + werwölfe + solo + switch 
var matches = [] 

func _on_searchbar_text_changed(new_text):
	new_text = new_text.to_lower()
	if new_text == "":
		for i in items:
			i.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Intro.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Dorfbewohner.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Werwölfe.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Wechselnde.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Einzelspieler.show()
		return
	matches.clear()
	for i in items:
		if new_text in i.name.to_lower():
			matches.append(i)
	for i in items:
		if i in matches:
			i.show()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Intro.hide()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Dorfbewohner.hide()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Werwölfe.hide()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Wechselnde.hide()
			$Panel/VBoxContainer/ScrollContainer/VBoxContainer/Einzelspieler.hide()
		else:
			i.hide()

func _on_button_back_pressed() -> void:
	visible = false
	get_parent()
