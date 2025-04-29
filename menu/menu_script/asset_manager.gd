extends Node
var role_paths = {
	1: "res://assets/cards/Child.png",
	2: "res://assets/cards/WolfChild.png",
	3: "res://assets/cards/Sisters.png",
	4: "res://assets/cards/Armor.png",
	5: "",
	6: "res://assets/cards/Girl.png",
	7: "res://assets/cards/GuardianAngel.png",
	8: "res://assets/cards/Seeress.png",
	9: "res://assets/cards/Wolf.png",
	10: "res://assets/cards/Urwolf.png",
	11: "res://assets/cards/BigWolf.png",
	12: "res://assets/cards/WhiteWolf.png",
	13: "res://assets/cards/Witch.png",
	14: "res://assets/cards/Fox.png",
	15: "res://assets/cards/Flute.png",
	16: "",
	17: "res://assets/cards/Bear.png",
	18: "res://assets/cards/Knight.png",
	19: "res://assets/cards/Tree.png",
	20: "res://assets/cards/Hunter.png",
	21: "res://assets/cards/Villager.png",
}

var status_path = {
	"enchanted": "res://assets/status/enchanted.png",
	"in_love": "res://assets/status/love.png",
	"idol": "res://assets/status/idol.png",
	"mayor": "res://assets/status/mayor.png",
	"infected": "res://assets/status/infected.png",
	"guard": "res://assets/status/guarded.png",
}

func load_role_texture(role_id: int) -> ImageTexture:
	var image_path = role_paths[role_id]
	var image = Image.load_from_file(image_path)
	var image_texture = ImageTexture.create_from_image(image)
	return image_texture

func load_status_texture(status: String) -> ImageTexture:
	if not status_path.has(status):
		push_error("Status not found: %s" % status)
		return null
	var image_path = status_path[status]
	var image = Image.load_from_file(image_path)
	return ImageTexture.create_from_image(image)
