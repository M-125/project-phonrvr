extends Camera
var sensitivity=5
# Override the _input function
func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Get the mouse motion
		
		var mouse_motion = event as InputEventMouseMotion
		# Adjust the camera rotation based on mouse movement
		rotation_degrees.y-=(deg2rad(mouse_motion.relative.x * sensitivity))
		rotation_degrees.x-=(deg2rad(mouse_motion.relative.y * sensitivity))
	if event is InputEventKey:
		if event.pressed and event.scancode==KEY_ESCAPE:
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		elif event.pressed and event.scancode==KEY_Q:
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
