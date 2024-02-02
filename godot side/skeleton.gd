extends MeshInstance
var connections=[[15, 21], [16, 20], [18, 20],  [14, 16], [23, 25], [28, 30], [11, 23], [27, 31],  [15, 17], [24, 26], [16, 22],  [29, 31], [12, 24], [23, 24],    [11, 13], [30, 32], [28, 32], [15, 19], [16, 18], [25, 27], [26, 28], [12, 14], [17, 19],  [11, 12], [27, 29], [13, 15]]
var wait=0
var fps=10
var z_array=[]

onready var sphere=get_node("sphere")
onready var tween=get_node("Tween")


onready var lshoulder=get_node("lshoulder")
onready var rshoulder=get_node("rshoulder")
onready var relbow=rshoulder.get_node("relbow")
onready var lelbow=lshoulder.get_node("lelbow")
onready var lhand=lelbow.get_node("lhand")
onready var rhand=relbow.get_node("rhand")
signal packet
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var socket = PacketPeerUDP.new()

func _ready():
	socket.listen(6000)
	print(CameraServer.feeds())

func _process(delta):
	if socket.get_available_packet_count() > 0:
		var data = socket.get_packet().get_string_from_ascii()
		data=data.split(";",false)
		mesh=ArrayMesh.new()
		var vertices = PoolVector3Array()
		var counter=0
		var pos=[]
		
		for e in data:
			
			var spos=e.split(",")
			
			spos=Vector3(spos[0],spos[1],spos[2])/1000
			spos=Vector3(2*spos.x,0,0)-spos
			spos.z=clamp(spos.z,-1,1)
			pos.push_back(spos)
		var z_average=0
		z_array.append((pos[0]+translation).z)
		for e in z_array:
			z_average+=e
		z_average/=z_array.size()
		tween.interpolate_property(sphere,"translation:x",sphere.translation.x,(pos[0]).x,0.3)
		tween.interpolate_property(sphere,"translation:y",sphere.translation.y,(pos[0]).y,0.3)
		tween.interpolate_property(sphere,"translation:z",sphere.translation.z,z_average,3)
		
		tween.interpolate_property(lhand,"translation",null,pos[15]-pos[13],2/fps)
		tween.interpolate_property(rhand,"translation",null,pos[16]-pos[14],2/fps)
		tween.interpolate_property(lelbow,"translation",null,pos[13]-pos[11],2/fps)
		tween.interpolate_property(relbow,"translation",null,pos[14]-pos[12],2/fps)
		tween.interpolate_property(lshoulder,"global_translation",null,to_global(pos[11]),2/fps)
		tween.interpolate_property(rshoulder,"global_translation",null,to_global(pos[12]),2/fps)
		tween.start()
		
		for e in connections:
			vertices.push_back(pos[e[0]])
			vertices.push_back(pos[e[1]])
		var arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		emit_signal("packet",pos)
#		arrays[ArrayMesh.ARRAY_INDEX]=connections
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
		if wait!=0:fps=1/wait
		wait=0
	wait+=delta

#var vertices = PoolVector3Array()
#vertices.push_back(Vector3(0, 1, 0))
#vertices.push_back(Vector3(1, 0, 0))
#vertices.push_back(Vector3(0, 0, 1))
## Initialize the ArrayMesh.
#var arr_mesh = ArrayMesh.new()
#var arrays = []
#arrays.resize(ArrayMesh.ARRAY_MAX)
#arrays[ArrayMesh.ARRAY_VERTEX] = vertices
## Create the Mesh.
#arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
#var m = MeshInstance.new()
#m.mesh = arr_mesh
