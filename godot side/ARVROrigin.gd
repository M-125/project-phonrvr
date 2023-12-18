extends ARVROrigin


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.vr:
		var interface = ARVRServer.find_interface("Native mobile")
		if interface and interface.initialize():
			get_viewport().arvr = true
			interface.eye_height=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.nolook:
		self.rotation.y=0-$ARVRCamera.rotation.y
