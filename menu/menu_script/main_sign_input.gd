extends Area3D

################################################################################
# Disclaimer: Browsing the Web for this has only resulted in outdated Projects 
# or others only written in C++ and not fitting for this specifically.
# Therefore I have used ChatGPT with Reasoning and Web-Search enabled to help 
# generate this code.
# --------- Prompt 1:
# In a Godot 4 Project i have a sign MeshInstance3D with a complex mesh where
# only one materia uses a Control node as a texture. i want to forward the
# necessary Inputs to the Control node. Generate a code based on this Structure
# Node3D
# - SubViewport
# -- Control
# 
# - MainSign
# -- Area3D
# --- CollisionShape3D
#
# --------- Prompt 2:
# The provided Code doen't work for LineEdit Nodes. Modify it to work for that
# aswell by forwarding the Inputs accordingly
################################################################################

@export var viewport: SubViewport
@export var ui_control: Control

var is_ui_focused := false
var focused_control: Control = null

func _ready():
	input_event.connect(_on_input_event)
	set_process_input(true)

func _on_input_event(camera, event, position, normal, shape_idx):
	if not (event is InputEventMouse or event is InputEventScreenTouch):
		return
	
	var aabb = get_parent().get_aabb()
	var mesh_local = to_local(position)
	
	var uv = Vector2(
		(mesh_local.x - aabb.position.x) / aabb.size.x,
		1.0 - ((mesh_local.y - aabb.position.y) / aabb.size.y)
	)
	var ui_pos = uv * Vector2(viewport.size)
	
	var new_event = event.duplicate()
	new_event.position = ui_pos
	
	if (event is InputEventMouseButton and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		var target_control = find_control_at_position(ui_pos, ui_control)
		if target_control:
			target_control.grab_focus()
			focused_control = target_control
			is_ui_focused = true
			if not focused_control.is_connected("focus_exited", Callable(self, "_on_focus_exited")):
				focused_control.connect("focus_exited", Callable(self, "_on_focus_exited"))
	
	viewport.push_input(new_event)

func _input(event):
	if is_ui_focused and event is InputEventKey:
		var new_event = event.duplicate()
		viewport.push_input(new_event)
		get_viewport().set_input_as_handled()

func _on_focus_exited():
	is_ui_focused = false
	focused_control = null

func find_control_at_position(pos: Vector2, control: Control) -> Control:
	if not control.visible:
		return null
	
	var local_pos = control.get_global_transform().affine_inverse() * pos
	
	if control.get_rect().has_point(local_pos):
		var children = control.get_children()
		children.reverse()
		
		for child in children:
			if child is Control:
				var found = find_control_at_position(pos, child)
				if found:
					return found
		return control
	return null
