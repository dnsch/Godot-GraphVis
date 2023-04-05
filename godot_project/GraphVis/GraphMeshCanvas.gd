extends Node2D

onready var node_mesh_instance = $NodeSprite
onready var node_multi_mesh_instance = $NodeMultiMesh

onready var edge_mesh_instance = $EdgesMesh

onready var gvis_obj = get_tree().get_root().get_node("Main").get("gvis")

onready var arr_mesh = ArrayMesh.new()
onready var arrays = []

onready var node_positions = []

onready var tmpMesh = MeshInstance2D.new()

func _ready():
	pass

func _draw_graph_mesh(color1, color2, color3, color4):
	gvis_obj = get_tree().get_root().get_node("Main").get("gvis")
	var node_multi_mesh = node_multi_mesh_instance.multimesh
	node_multi_mesh.mesh = node_mesh_instance.mesh
	node_multi_mesh.instance_count = gvis_obj.graph_number_of_nodes()
	
	var vertices = PoolVector3Array()
	var colors = PoolColorArray()
	
	var nodes = 0
	var edges = 0
	
	var counter = 0
	for node in range(gvis_obj.graph_number_of_nodes()):
		print("yaa")
		var node_transform = Transform2D( 2.0, Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		node_transform.x *= 0.01
		node_transform.y *= 0.01
		node_multi_mesh.set_instance_transform_2d(node, node_transform)
		nodes += 1
		node_positions.push_back(counter)
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			vertices.push_back(Vector3(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node), 0))
			colors.push_back(color1)
			counter += 1
			vertices.push_back(Vector3(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target),0))
			colors.push_back(color2)
			edges += 1
			counter+= 1
	var curr_arr_mesh = ArrayMesh.new()
	var curr_arrays = []
	curr_arrays.resize(ArrayMesh.ARRAY_MAX)
	curr_arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	curr_arrays[ArrayMesh.ARRAY_COLOR] = colors
	for vertex in range(50):
		curr_arrays[ArrayMesh.ARRAY_COLOR][vertex] = Color( 0, 0, 1, .1)
	# Create the Mesh.
	curr_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, curr_arrays)
	edge_mesh_instance.mesh = curr_arr_mesh
	arr_mesh = curr_arr_mesh
	arrays = curr_arrays
	pass
	
func _change_vertex_color(vertices, color):
	var curr_arrays = arrays
	var new_array_mesh = ArrayMesh.new()
	var target
	for node in vertices:
		curr_arrays[ArrayMesh.ARRAY_COLOR][node_positions[node]] = color
	new_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, curr_arrays)
	arrays = curr_arrays
	arr_mesh = new_array_mesh
	edge_mesh_instance.mesh = arr_mesh

func _redraw_edge_mesh(vertices, colors):
	for node in range(gvis_obj.graph_number_of_nodes()):
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			vertices.push_back(Vector3(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node), 0))
			if vertices.has(node):
				colors.push_back(colors[1])
			else:
				colors.push_back(colors[0])
			vertices.push_back(Vector3(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target),0))
			if vertices.has(node):
				colors.push_back(colors[1])
			else:
				colors.push_back(colors[0])

	var curr_arr_mesh = ArrayMesh.new()
	var curr_arrays = []
	curr_arrays.resize(ArrayMesh.ARRAY_MAX)
	curr_arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	curr_arrays[ArrayMesh.ARRAY_COLOR] = colors
	for vertex in range(50):
		curr_arrays[ArrayMesh.ARRAY_COLOR][vertex] = Color( 0, 0, 1, .1)
	# Create the Mesh.
	curr_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, curr_arrays)
	edge_mesh_instance.mesh = curr_arr_mesh
	arr_mesh = curr_arr_mesh
	arrays = curr_arrays
	pass

func _draw_new_mesh(selected_vertices, selected_color, mesh_instance):
	var mesh_vertices = PoolVector3Array()
	var mesh_colors = PoolColorArray()
	
	for node in selected_vertices:
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			mesh_vertices.push_back(Vector3(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node), 0))
			mesh_colors.push_back(selected_color)
			mesh_vertices.push_back(Vector3(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target),0))
			mesh_colors.push_back(selected_color)

	var curr_arr_mesh = ArrayMesh.new()
	var curr_arrays = []
	curr_arrays.resize(ArrayMesh.ARRAY_MAX)
	curr_arrays[ArrayMesh.ARRAY_VERTEX] = mesh_vertices
	curr_arrays[ArrayMesh.ARRAY_COLOR] = mesh_colors
	curr_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, curr_arrays)
	mesh_instance.mesh = curr_arr_mesh
	pass
