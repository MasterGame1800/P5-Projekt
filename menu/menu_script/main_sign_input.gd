"""
This script extends the Area3D class and forwards input events to a Control node used as a texture.

Variables:
- viewport: The SubViewport containing the UI.
- ui_control: The Control node receiving the forwarded inputs.
- is_ui_focused: Boolean indicating if the UI is focused.
- focused_control: The currently focused Control node.

Functions:
- _ready: Connects the input event signal and enables input processing.
- _on_input_event: Handles input events and forwards them to the UI.
- _input: Forwards key input events to the UI when focused.
- _on_focus_exited: Resets the focus state when the UI loses focus.
- find_control_at_position: Finds the Control node at a given position.
"""

extends Area3D

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
