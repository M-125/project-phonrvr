extends ARVROrigin
onready var tween=get_parent().get_parent().get_node("Tween")
var rot=0
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
		self.rotation.y=rot-$ARVRCamera.rotation.y


func _on_Spatial_packet(pack):
	if Global.nolook:
		var pos1 = Vector2(pack[11].x, pack[11].z)
		var pos2 = Vector2(pack[12].x, pack[12].z)
		var rott = -pos1.angle_to_point(pos2)

		rott = fmod(rott + TAU, TAU)
		rot = fmod(rot + TAU, TAU)

		var diff = rot - rott
		if abs(diff) > PI:
			if diff > 0:
				rott += TAU
			else:
				rot += TAU

		var tween_duration = 0.2
		tween.interpolate_property(self, "rot", rot, rott, tween_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()


