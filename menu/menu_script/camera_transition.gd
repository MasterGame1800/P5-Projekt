extends Node3D

var current_camera: Camera3D
var target_camera: Camera3D
var blend_time := 0.5
var blend_timer := 0.0
var is_blending := false

@onready var blend_camera: Camera3D  = $BlendCamera
@onready var session_gui: Control  = $SessionGUI

func start_camera_blend(from: Camera3D, to: Camera3D):
	if to == $MainCamera:
		session_gui.hide()
	if not is_blending:
		is_blending = true
		blend_timer = 0.0
		current_camera = from
		target_camera = to
		blend_camera.global_transform = from.global_transform
		blend_camera.make_current()

func _process(delta: float) -> void:
	if is_blending:
		blend_timer += delta
		var t = clamp(blend_timer / blend_time, 0.0, 0.4)
		blend_camera.global_transform = blend_camera.global_transform.interpolate_with(target_camera.global_transform, t)

		if t >= 0.4:
			is_blending = false
			target_camera.make_current()
			if target_camera == $SessionCamera:
				session_gui.show()
