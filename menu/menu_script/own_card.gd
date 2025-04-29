"""
This script extends the Control class and manages the behavior of a card in the game.

Variables:
- card_rect: The rectangle representing the card.
- current_status: List of current statuses applied to the card.

Functions:
- _on_texture_rect_mouse_entered: Animates the card when the mouse enters.
- _on_texture_rect_mouse_exited: Animates the card when the mouse exits.
- _animate_card: Handles the animation of the card.
- set_texture: Sets the texture of the card based on the role ID.
- add_status: Adds a status icon to the card.
- remove_status: Removes a status icon from the card.
- update_status: Updates the card's statuses based on the player's properties.
- _ready: Initializes the card with a default texture and status.
"""

extends Control

@onready var card_rect = $CardRect
var current_status = []

func _on_texture_rect_mouse_entered() -> void:
	_animate_card(0.54, 1.0)

func _on_texture_rect_mouse_exited() -> void:
	_animate_card(0.74, 1.2)

func _animate_card(new_anchor_top: float, new_anchor_bottom: float) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(card_rect, "anchor_top", new_anchor_top, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_rect, "anchor_bottom", new_anchor_bottom, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func set_texture(role_id):
	var asset_manager = get_parent().get_node("AssetManager")
	var texture = asset_manager.load_role_texture(role_id)
	card_rect.texture = texture

func add_status(status_name: String):
	var asset_manager = get_parent().get_node("AssetManager")
	var texture = asset_manager.load_status_texture(status_name)
	if texture == null:
		return

	var status_image = TextureRect.new()
	status_image.name = status_name
	status_image.texture = texture
	status_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	card_rect.get_node("HBoxContainer").add_child(status_image)


func remove_status(status_name: String):
	var container = card_rect.get_node("HBoxContainer")
	if container.has_node(status_name):
		var status_node = container.get_node(status_name)
		status_node.queue_free()


func update_status(player) -> Array:
	current_status = []
	var bool_properties = [
		"enchanted", "in_love", "idol",
		"mayor", "infected", "sleepover", "guard"
	]
	for status in bool_properties:
		if player.get(status):
			current_status.append(status)

	return current_status

func _ready():
	set_texture(6)
	add_status("enchanted")
