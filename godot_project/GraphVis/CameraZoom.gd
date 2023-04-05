extends Camera2D

#Taken from: https://www.gdquest.com/tutorial/godot/2d/camera-zoom/
#and Keeyans answer from https://godotengine.org/qa/24969/how-to-drag-camera-with-mouse
# Lower cap for the `_zoom_level`.
export var min_zoom := .01
# Upper cap for the `_zoom_level`.
export var max_zoom := 3
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := .05
# Duration of the zoom's tween animation.
export var zoom_duration := 0.2
onready var node_info_panel = get_tree().get_root().get_node("Main/NodeInfo/NodeInfoPanel")
export var rotation_speed := 4
# The camera's target zoom level.
var _zoom_level := 1.0 setget _set_zoom_level
# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween
var mouse_start_pos
var screen_start_position
var dragging = false
var rotating_screen = false

func ready():
	GlobalSettings.connect("option_changes_reset", self, "_on_option_changes_reset")
	GlobalVariables.current_zoom_level = _zoom_level

func _set_zoom_level(value: float) -> void:
	GlobalVariables.graph_moving = true
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()
	GlobalVariables.current_zoom_level = _zoom_level
	GlobalVariables.graph_moving = false

func _on_option_changes_reset():
	_zoom_level = 1.0
	position = Vector2(0,0)
	get_parent().get_parent().get_node("MeshNode2D").rotation_degrees = 0

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
		# call the setter function to use it.
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_MIDDLE:
			GlobalVariables.graph_moving = true
			position -= event.relative * zoom
			position.x = clamp(position.x, -(OS.get_window_size().x * max_zoom)/2,(OS.get_window_size().x * max_zoom)/2)
			position.y = clamp(position.y, -(OS.get_window_size().y * max_zoom)/2,(OS.get_window_size().y * max_zoom)/2)
			GlobalVariables.graph_moving = false
	if event.is_action("rotate"):
		if event.is_pressed():
			GlobalVariables.graph_moving = true
			mouse_start_pos = get_camera_screen_center() + event.position
			rotating_screen = true
			GlobalVariables.graph_moving = false
		else:
			rotating_screen = false
	elif event is InputEventMouseMotion and rotating_screen:
		GlobalVariables.graph_moving = true
		get_parent().get_parent().get_node("MeshNode2D").rotation_degrees += mouse_start_pos.angle_to(event.position)*rotation_speed
		GlobalVariables.graph_moving = false

func get_zoom_amount():
  return get_zoom();
