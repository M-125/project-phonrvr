extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Pm.connect("pack",self,"pack")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func pack(pack):
	position=Vector2(pack[16].x,pack[16].y)/2*get_viewport_rect().size
	
	pass
