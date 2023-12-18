extends Area
onready var hands={"lhand":get_parent().get_node("lhand"),"rhand":get_parent().get_node("rhand")}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var material=SpatialMaterial.new()
	randomize()
	material.albedo_color=Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	$MeshInstance.material_override=material
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if overlaps_area(hands["rhand"]) and Input.is_action_pressed("righthand"):
		translation=hands["rhand"].translation
	if overlaps_area(hands["lhand"]) and Input.is_action_pressed("lefthand"):
		translation=hands["lhand"].translation
#	pass
