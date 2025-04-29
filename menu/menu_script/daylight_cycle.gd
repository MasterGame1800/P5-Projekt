extends DirectionalLight3D

"""
This script extends the DirectionalLight3D class and manages the day-night cycle in the game.

Variables:
- max_light_energy: Maximum light energy during the day.
- min_light_energy: Minimum light energy during the night.
- light_color_day: Light color during the day.
- light_color_night: Light color during the night.
- ambient_color_day: Ambient light color during the day.
- ambient_color_night: Ambient light color during the night.
- transition_duration: Duration of the transition between day and night.
- world_environment: The world environment node.
- sky_material: Shader material for the sky.
- sky_top_color_day: Top sky color during the day.
- sky_top_color_night: Top sky color during the night.
- sky_horizon_color_day: Horizon sky color during the day.
- sky_horizon_color_night: Horizon sky color during the night.
- sun_color_day: Sun color during the day.
- sun_color_night: Sun color during the night.
- sun_size_day: Sun size during the day.
- sun_size_night: Sun size during the night.
- is_day: Boolean indicating whether it is currently day.

Functions:
- toggle_daynight: Toggles between day and night.
- set_sky_top_color: Sets the top sky color.
- set_sky_horizon_color: Sets the horizon sky color.
- set_sun_color: Sets the sun color.
- set_sun_size: Sets the sun size.
- _ready: Initializes the light and ambient colors for the day.
"""

@export var max_light_energy: float = 1.5
@export var min_light_energy: float = 0.1
@export var light_color_day: Color = Color(1.0, 0.95, 0.9)
@export var light_color_night: Color = Color(0.3, 0.4, 0.9)
@export var ambient_color_day: Color = Color(0.6, 0.6, 0.6)
@export var ambient_color_night: Color = Color(0.1, 0.1, 0.2)
@export var transition_duration: float = 5.0

@export var world_environment: WorldEnvironment
@export var sky_material: ShaderMaterial

@export var sky_top_color_day: Color = Color(0.3, 0.5, 0.9)
@export var sky_top_color_night: Color = Color(0.0, 0.0, 0.1)
@export var sky_horizon_color_day: Color = Color(0.7, 0.8, 1.0)
@export var sky_horizon_color_night: Color = Color(0.1, 0.1, 0.3)
@export var sun_color_day: Color = Color(1.0, 0.9, 0.8)
@export var sun_color_night: Color = Color(0.4, 0.4, 0.8)
@export var sun_size_day: float = 0.2
@export var sun_size_night: float = 0.1

var is_day: bool = true

func toggle_daynight():
	var target_energy = min_light_energy if is_day else max_light_energy
	var target_color = light_color_night if is_day else light_color_day
	var target_ambient = ambient_color_night if is_day else ambient_color_day
	
	var target_sky_top = sky_top_color_night if is_day else sky_top_color_day
	var target_sky_horizon = sky_horizon_color_night if is_day else sky_horizon_color_day
	var target_sun_color = sun_color_night if is_day else sun_color_day
	var target_sun_size = sun_size_night if is_day else sun_size_day
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "light_energy", target_energy, transition_duration)
	tween.tween_property(self, "light_color", target_color, transition_duration)
	
	if world_environment and world_environment.environment:
		tween.tween_property(world_environment.environment, "ambient_light_color",
			target_ambient, transition_duration)
	
	if sky_material:
		tween.tween_method(set_sky_top_color, sky_material.get_shader_parameter("skyColor"),
			target_sky_top, transition_duration)
		tween.tween_method(set_sky_horizon_color, sky_material.get_shader_parameter("horizonColor"),
			target_sky_horizon, transition_duration)
		tween.tween_method(set_sun_color, sky_material.get_shader_parameter("sun_color"),
			target_sun_color, transition_duration)
		tween.tween_method(set_sun_size, sky_material.get_shader_parameter("sun_size"),
			target_sun_size, transition_duration)
	
	is_day = !is_day

func set_sky_top_color(value: Color):
	sky_material.set_shader_parameter("skyColor", value)

func set_sky_horizon_color(value: Color):
	sky_material.set_shader_parameter("horizonColor", value)

func set_sun_color(value: Color):
	sky_material.set_shader_parameter("sun_color", value)

func set_sun_size(value: float):
	sky_material.set_shader_parameter("sun_size", value)
	
func _ready():
	light_energy = max_light_energy
	light_color = light_color_day
	if world_environment and world_environment.environment:
		world_environment.environment.ambient_light_color = ambient_color_day
