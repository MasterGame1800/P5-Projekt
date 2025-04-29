extends Node3D


@export var game_camera = Camera3D
@export var base_card_size = Vector2(1, 1.3)
@export var front_material : Material
@export var back_material : Material
@export var side_material : Material
var materials = []

var y_pos : float
var player_count : int

# log coordinates counted clockwise
var log_list = [
	PackedVector3Array([Vector3(2.5, 0, 2.1), Vector3(0.4, 0, 2.1)]),
	PackedVector3Array([Vector3(0.1, 0, 1.9), Vector3(-1.4, 0, 0.65)]),
	PackedVector3Array([Vector3(-1.4, 0, 0.25), Vector3(-1.4, 0, -1.5)]),
	PackedVector3Array([Vector3(-1.1, 0, -2), Vector3(0.1, 0, -3.4)]),
	PackedVector3Array([Vector3(0.7, 0, -3.5), Vector3(2.6, 0, -3.5)])
]
const log_order = [2, 1, 3, 0, 4]  # Priority for filling logs
const size_factor = [0.8, 0.6, 0.4, 0.3, 0.25, 0.2] # Multiplier for card size based on 

var card_positions = PackedVector3Array()
var cards: Array = []
var card_table = {}

func generate_cards(count: int = 8):
	count -= 1 # Minus own Player Card
	var size = size_factor[(count - 1) / 5 - 1] * base_card_size
	y_pos = 1.8 + (float(size.y) / 2)
	_generate_positions(count)
	
	for i in cards:
		i.queue_free()
	cards.clear()
	
	for pos in card_positions:
		var card = MeshInstance3D.new()
		var box_mesh = _create_mesh(Vector3(size.x, size.y, 0.025))
		
		for surface_idx in box_mesh.get_surface_count():
			box_mesh.surface_set_material(surface_idx, materials[surface_idx])
		
		card.mesh = box_mesh
		var look_coordinates = Vector3(1.6, y_pos, -0.6)
		add_child(card)
		card.global_position = pos
		card.look_at(look_coordinates, Vector3.UP)
		
		var area = Area3D.new()
		var collision = CollisionShape3D.new()
		collision.shape = BoxShape3D.new()
		collision.shape.size = Vector3(size.x, size.y, 0.025)
		area.add_child(collision)
		card.add_child(area)
		
		area.mouse_entered.connect(_on_card_hovered.bind(card))
		area.mouse_exited.connect(_on_card_unhovered.bind(card))
		
		var billboard = preload("res://menu/menu_scene_3d/HoverSprite.tscn").instantiate()
		billboard.name = "BillboardText"
		billboard.get_node("Sprite3D").visible = false
		billboard.position = Vector3(0, size.y * 0.6, 0)
		card.add_child(billboard)
		
		var label = billboard.get_node("Sprite3D/SubViewport/Label")
		label.text = "Card " + str(cards.size())
		
		cards.append(card)

func _generate_positions(amount: int):
	var base_amount = amount / 5
	var extra_amount = amount % 5
	card_positions = PackedVector3Array()
	
	var log_amounts = []
	for i in range(5):
		log_amounts.append(base_amount)
	for i in range(extra_amount):
		var log_index = log_order[i]
		log_amounts[log_index] += 1
	
	for log_index in range(5):
		var log = log_list[log_index]
		var log_count = log_amounts[log_index]
		var positions = _generate_log_positions(log, log_count)
		card_positions.append_array(positions)

func _generate_log_positions(log: PackedVector3Array, count: int) -> PackedVector3Array:
	var positions = PackedVector3Array()
	var log_vector = log[0] - log[1]
	var y_vector = Vector3(0, y_pos, 0)
	
	if count == 0:
		return positions
	
	else:
		for i in range(count):
			positions.append(log[0] - (log_vector * (i + 0.5) / count) + y_vector)
	
	return positions

func _create_mesh(size: Vector3) -> ArrayMesh:
	var array_mesh = ArrayMesh.new()
	var st = SurfaceTool.new()
	
	var hx = size.x / 2.0
	var hy = size.y / 2.0
	var hz = size.z / 2.0
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[0])
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-hx, -hy, hz))
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(hx, hy, hz))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(hx, -hy, hz))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-hx, -hy, hz))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-hx, hy, hz))
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(hx, hy, hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[1])
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(hx, -hy, -hz))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-hx, hy, -hz))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-hx, -hy, -hz))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(hx, -hy, -hz))
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(hx, hy, -hz))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-hx, hy, -hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[2])
	st.add_vertex(Vector3(hx, -hy, hz))
	st.add_vertex(Vector3(hx, hy, -hz))
	st.add_vertex(Vector3(hx, -hy, -hz))
	st.add_vertex(Vector3(hx, -hy, hz))
	st.add_vertex(Vector3(hx, hy, hz))
	st.add_vertex(Vector3(hx, hy, -hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[3])
	st.add_vertex(Vector3(-hx, -hy, -hz))
	st.add_vertex(Vector3(-hx, hy, hz))
	st.add_vertex(Vector3(-hx, -hy, hz))
	st.add_vertex(Vector3(-hx, -hy, -hz))
	st.add_vertex(Vector3(-hx, hy, -hz))
	st.add_vertex(Vector3(-hx, hy, hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[4])
	st.add_vertex(Vector3(-hx, hy, hz))
	st.add_vertex(Vector3(hx, hy, -hz))
	st.add_vertex(Vector3(hx, hy, hz))
	st.add_vertex(Vector3(-hx, hy, hz))
	st.add_vertex(Vector3(-hx, hy, -hz))
	st.add_vertex(Vector3(hx, hy, -hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(materials[5])
	st.add_vertex(Vector3(-hx, -hy, -hz))
	st.add_vertex(Vector3(hx, -hy, hz))
	st.add_vertex(Vector3(-hx, -hy, hz))
	st.add_vertex(Vector3(-hx, -hy, -hz))
	st.add_vertex(Vector3(hx, -hy, -hz))
	st.add_vertex(Vector3(hx, -hy, hz))
	st.generate_normals()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, st.commit_to_arrays())
	
	return array_mesh

func _on_card_hovered(card: MeshInstance3D):	
	var sprite = card.get_node("BillboardText/Sprite3D")
	sprite.visible = true

func _on_card_unhovered(card: MeshInstance3D):
	var sprite = card.get_node("BillboardText/Sprite3D")
	sprite.visible = false

func set_hover_text(card: MeshInstance3D, text: String):
	var viewport = card.get_node("BillboardText/Sprite3D/SubViewport")
	viewport.get_node("Label").text = text

func flip(player):
	var tween = create_tween()
	for index in player.size():
		var current_card = card_table[player[index]]
	
		tween.tween_property(
			current_card,
			"rotation_degrees:y",
			current_card.rotation_degrees.y + 180.0,
			0.5
		).set_trans(Tween.TRANS_SINE)

func set_front_texture(card: MeshInstance3D, role):
	var asset_manager = $AssetManager
	var texture = asset_manager.load_role_texture(role)
	var image_material = StandardMaterial3D.new()
	image_material.albedo_texture = texture
	
	card.mesh.surface_set_material(0, image_material)

func set_player_data(players):
	for index in cards.size():
		card_table[players[index]] = cards[index]
	print(card_table)

func _ready():
	back_material.albedo_texture = preload("res://assets/cards/Backside.png")
	materials = [front_material, back_material, side_material, 
	side_material, side_material, side_material]
	generate_cards(player_count)
	set_hover_text(cards[0], "TEst")
