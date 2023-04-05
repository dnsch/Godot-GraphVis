extends Node2D

onready var node_mesh_instance = $NodeSprite2
onready var node_multi_mesh_instance = $NodeMultiMesh2

onready var node_mesh_instance_old = $NodeSprite
onready var node_multi_mesh_instance_old = $NodeMultiMesh

onready var arrow_mesh_instance = $ArrowSprite
onready var arrow_multi_mesh_instance = $ArrowMultiMesh
onready var path_multi_mesh_instance = $PathMultiMesh
onready var arrow_border_multi_mesh_instance = $ArrowBorderMultiMesh
onready var edge_mesh_instance = $EdgesMesh
onready var path_mesh_instance = $PathMesh

onready var selection_mesh_instance = $SelectionMesh
onready var selection_multi_mesh_instance = $SelectionMultiMesh
onready var arrow_mesh_instance2 = $ArrowSprite2
onready var arrow_multi_mesh_instance2 = $ArrowMultiMesh2
onready var arrow_border_multi_mesh_instance2 = $ArrowBorderMultiMesh2


var node_multi_mesh
var arrow_multi_mesh

onready var gvis_obj = GlobalVariables.gvis_obj

onready var arr_mesh = ArrayMesh.new()
onready var arrays = []

onready var path_arr_mesh = ArrayMesh.new()
onready var path_arrays = []

onready var selection_arr_mesh = ArrayMesh.new()
onready var selection_arrays = []

onready var triangle_strip_arr_mesh = ArrayMesh.new()
onready var triangle_strip_arrays = []

onready var node_positions_in_array = []

onready var tmpMesh = MeshInstance2D.new()

onready var node_positions = []

onready var node_color = Color(1,1,1,1)
onready var node_alpha = 1
onready var node_sprite_png_scale = 0.25
onready var node_size = 0.01
onready var arrow_size = 0.001

onready var edge_color = Color(1,1,1,1)
onready var edge_colors = PoolColorArray()
onready var edge_vertices = PoolVector2Array()
onready var edge_colors_triangle_strip = PoolColorArray()
onready var edge_vertices_triangle_strip = PoolVector2Array()
onready var edge_alpha = 1
onready var edge_size = node_size * 5

onready var triangle_strip = false
onready var curr_triangle_strip_width = 0.3

onready var edge_gradients = []

onready var edge_gradients_colors = []


func _ready():
	GlobalSettings.connect("node_visibility_toggled", self, "_on_node_visibility_toggled")
	GlobalSettings.connect("arrow_visibility_toggled", self, "_on_arrow_visibility_toggled")
	GlobalSettings.connect("node_color_changed", self, "_on_node_color_changed")
	GlobalSettings.connect("node_alpha_changed", self, "_on_node_alpha_changed")
	GlobalSettings.connect("node_size_changed", self, "_on_node_size_changed")
	GlobalSettings.connect("degree_size_list_change_applied", self, "_on_degree_size_list_change_applied")
	GlobalSettings.connect("edge_visibility_toggled", self, "_on_edge_visibility_toggled")
	GlobalSettings.connect("edge_color_changed", self, "_on_edge_color_changed")
	GlobalSettings.connect("edge_alpha_changed", self, "_on_edge_alpha_changed")
	GlobalSettings.connect("edge_size_changed", self, "_on_edge_size_changed")
	GlobalSettings.connect("edge_triangle_strip_changed", self, "_on_edge_triangle_strip_changed")
	GlobalSettings.connect("gradient_colors_change_applied", self, "_on_gradient_colors_change_applied")
	GlobalSettings.connect("quantiles_list_initialized", self, "_on_quantiles_list_init_call")
	GlobalSettings.connect("gradient_list_changed", self, "_on_gradient_list_changed")
	GlobalSettings.connect("node_partition_colors_change_applied", self, "_on_node_partition_colors_change_applied")
	GlobalSettings.connect("edge_partition_colors_change_applied", self, "_on_edge_partition_colors_change_applied")
	GlobalSettings.connect("node_vertex_set_colors_change_applied", self, "_on_node_vertex_set_colors_change_applied")
	GlobalSettings.connect("edge_vertex_set_colors_change_applied", self, "_on_edge_vertex_set_colors_change_applied")
	GlobalSettings.connect("option_changes_reset", self, "_on_option_changes_reset")
	path_mesh_instance.z_index=-1
	path_multi_mesh_instance.z_index=1
	edge_mesh_instance.z_index=-1
	arrow_mesh_instance.z_index=0
	arrow_multi_mesh_instance.z_index=0
	node_mesh_instance.z_index=1
	node_multi_mesh_instance.z_index=1
	
	selection_mesh_instance.z_index=-1
	selection_multi_mesh_instance.z_index=0
	arrow_multi_mesh_instance2.z_index=0
	
	GlobalVariables.node_multi_mesh_instance = node_multi_mesh_instance
	
	selection_mesh_instance.visible = false
	selection_multi_mesh_instance.visible = false
	arrow_mesh_instance2.visible = false
	arrow_multi_mesh_instance2.visible = false
	arrow_border_multi_mesh_instance2.visible = false
	pass

func _on_option_changes_reset():
	arrays = []
	path_arrays = []
	triangle_strip_arrays = []
	node_positions_in_array = []
	node_positions = []
	node_color = Color(1,1,1,1)
	node_alpha = 1
	node_sprite_png_scale = 0.25
	node_size = 0.01
	arrow_size = 0.001
	edge_color = Color(1,1,1,1)
	edge_alpha = 1
	edge_size = node_size * 5
	triangle_strip = false
	curr_triangle_strip_width = 0.3
	edge_gradients = []
	edge_gradients_colors = []

#nodes
func _on_node_visibility_toggled(value):
	node_multi_mesh_instance.visible = value
	node_multi_mesh_instance_old.visible = value

func _on_node_color_changed(value):
	_change_node_mesh_color(value)

func _on_node_alpha_changed(value):
	_change_node_mesh_alpha(value)

func _on_node_size_changed(value):
	_change_node_mesh_node_size(value)
	
func _on_degree_size_list_change_applied():
	_change_node_mesh_node_degree_size()
	
func _change_node_mesh_color(color):
	node_color = color
	for node in range(gvis_obj.graph_number_of_nodes()):
		node_multi_mesh_instance.multimesh.set_instance_color(node, color)
		GlobalVariables.node_colors[node] = node_color

func _change_node_mesh_alpha(alpha):
	node_color.a = alpha
	var curr_color
	for node in range(gvis_obj.graph_number_of_nodes()):
		curr_color = GlobalVariables.node_colors[node]
		curr_color.a = alpha
		node_multi_mesh_instance_old.multimesh.set_instance_color(node, curr_color)

func _change_node_mesh_node_size(size):
	node_size = size
	var target_x
	var target_y
	var node_x
	var node_y
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9) * node_size
	var edges
	
	arrow_multi_mesh = arrow_multi_mesh_instance.multimesh
	arrow_multi_mesh.mesh = arrow_mesh_instance.mesh
	arrow_multi_mesh.instance_count = gvis_obj.graph_number_of_edges()
	
	for node in range(gvis_obj.graph_number_of_nodes()):
		var node_transform = Transform2D( 2.0, Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		node_transform.x *= size
		node_transform.y *= size
		node_multi_mesh_instance.multimesh.set_instance_transform_2d(node, node_transform)
		node_x = gvis_obj.graph_getX(node)
		node_y = gvis_obj.graph_getY(node)
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			target_x = gvis_obj.graph_getX(target)
			target_y = gvis_obj.graph_getY(target)
			
			var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
			var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
			var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
			var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_size/2))
			
			target_transform.x *= arrow_size
			target_transform.y *= arrow_size

			arrow_multi_mesh.set_instance_transform_2d(edge, target_transform)

func _change_node_mesh_node_degree_size():
	var node_degree_size
	
	arrow_multi_mesh = arrow_multi_mesh_instance.multimesh
	arrow_multi_mesh.mesh = arrow_mesh_instance.mesh
	arrow_multi_mesh.instance_count = gvis_obj.graph_number_of_edges()
	
	var target_x
	var target_y
	var node_x
	var node_y
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9)
	var target_degree_size
	for node in range(gvis_obj.graph_number_of_nodes()):
		node_degree_size = GlobalVariables.degrees_with_sizes[gvis_obj.graph_getNodeDegree(node)]
		var node_transform = Transform2D( 2.0, Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		node_transform.x *= node_degree_size
		node_transform.y *= node_degree_size
		node_multi_mesh_instance.multimesh.set_instance_transform_2d(node, node_transform)
		GlobalVariables.node_sizes[node] = node_degree_size
		node_x = gvis_obj.graph_getX(node)
		node_y = gvis_obj.graph_getY(node)
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			target_x = gvis_obj.graph_getX(target)
			target_y = gvis_obj.graph_getY(target)
			target_degree_size = GlobalVariables.degrees_with_sizes[gvis_obj.graph_getNodeDegree(target)]
			var node_sprite_degree_size = node_sprite_size * target_degree_size
			var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
			var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
			var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
			var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_degree_size/2))
			
			target_transform.x *= arrow_size
			target_transform.y *= arrow_size
			
			arrow_multi_mesh.set_instance_transform_2d(edge, target_transform)

#edges
func _on_edge_visibility_toggled(value):
	edge_mesh_instance.visible = value
	
func _on_arrow_visibility_toggled(value):
	arrow_multi_mesh_instance.visible = value
	arrow_border_multi_mesh_instance.visible = value

func _on_edge_color_changed(value):
	_change_edge_mesh_color(value)

func _on_edge_alpha_changed(value):
	_change_edge_mesh_alpha(value)
#
func _on_edge_size_changed(value):
	_change_edge_mesh_edge_size(value)
	curr_triangle_strip_width = value

func _on_edge_triangle_strip_changed(value):
	triangle_strip = value
	_change_edge_mesh_edge_size(curr_triangle_strip_width)

func _on_gradient_colors_change_applied():
	if (GlobalVariables.quantiles_initialized == false):
		_init_gradients()
		GlobalVariables.quantiles_initialized = true
	var color
	_change_edge_mesh_color_gradients(color)

func _on_quantiles_list_init_call():
	_init_gradients()
	GlobalVariables.quantiles_initialized = true

func _on_gradient_list_changed(value):
	if (GlobalVariables.gradients_changed == false):
		_init_gradients()
		GlobalVariables.gradients_changed = true

func _change_edge_mesh_alpha(value):
	if (triangle_strip == false):
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			var counter = 0
			var edge_size = gvis_obj.graph_number_of_edges()
			
			for single_color in arrays[ArrayMesh.ARRAY_COLOR]:
				single_color.a = value
				new_colors.push_back(single_color)
				if(counter < edge_size):
					single_color = arrow_multi_mesh_instance.multimesh.get_instance_color(counter)
					single_color.a = value
					arrow_multi_mesh_instance.multimesh.set_instance_color(counter, single_color)
					counter += 1
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	else:
		var new_colors = PoolColorArray()
		var counter = 0
		var edge_size = gvis_obj.graph_number_of_edges()
		for single_color in arrays[ArrayMesh.ARRAY_COLOR]:
			single_color.a = value
			new_colors.push_back(single_color)
			if(counter < edge_size):
				single_color = arrow_multi_mesh_instance.multimesh.get_instance_color(counter)
				single_color.a = value
				arrow_multi_mesh_instance.multimesh.set_instance_color(counter, single_color)
				counter += 1
		arrays[ArrayMesh.ARRAY_COLOR] = new_colors
		arr_mesh.surface_remove(0)
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	edge_alpha = value

func _change_edge_mesh_color(color):
	if (triangle_strip == false):
		edge_color = color
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			var counter = 0
			var edge_size = gvis_obj.graph_number_of_edges()
			for single_color in arrays[ArrayMesh.ARRAY_COLOR]:
				color.a = single_color.a
				new_colors.push_back(color)
				if(counter < edge_size):
					arrow_multi_mesh_instance.multimesh.set_instance_color(counter, color)
					GlobalVariables.edge_colors[counter] = color
					counter += 1
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	else:
		edge_color = color
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			var counter = 0
			var edge_size = gvis_obj.graph_number_of_edges()
			for single_color in arrays[ArrayMesh.ARRAY_COLOR]:
				color.a = single_color.a
				new_colors.push_back(color)
				if(counter < edge_size):
					arrow_multi_mesh_instance.multimesh.set_instance_color(counter, color)
					GlobalVariables.edge_colors[counter] = color
					counter += 1
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

func _change_edge_mesh_color_gradients(color):
	
	if (GlobalVariables.gradients_changed == false):
		GlobalSettings.change_quantiles_list()
		GlobalVariables.gradients_changed = true
	
	if (triangle_strip == false):
		edge_color = color
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			var max_quantile_nr = GlobalVariables.probs.size()
			var plain_coloring = GlobalVariables.plain_coloring
			for node in range(gvis_obj.graph_number_of_nodes()):
				var target
				for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
					target = gvis_obj.graph_getEdgeTarget(edge)
					if (plain_coloring == false):
						var edge_gradient
						var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
						if (edge_quantile_nr == max_quantile_nr-1):
							edge_gradient = edge_gradients[max_quantile_nr-2]
						else:
							edge_gradient = edge_gradients[edge_quantile_nr-1]
						var gradient_color = edge_gradient.interpolate(gvis_obj.graph_get_edge_lengths_quartile_pct(edge))
						new_colors.push_back(gradient_color)
						new_colors.push_back(gradient_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, gradient_color)
						GlobalVariables.edge_colors[edge] = edge_color
					else:
						var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
						if (edge_quantile_nr == max_quantile_nr-1):
							edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
						elif (edge_quantile_nr == 0):
							edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr]]
						else:
							edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
						new_colors.push_back(edge_color)
						new_colors.push_back(edge_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, edge_color)
						GlobalVariables.edge_colors[edge] = edge_color
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	else:
		edge_color = color
		var new_colors = PoolColorArray()
		var max_quantile_nr = GlobalVariables.probs.size()
		var plain_coloring = GlobalVariables.plain_coloring
		
		for node in range(gvis_obj.graph_number_of_nodes()):
			var target
			for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
				target = gvis_obj.graph_getEdgeTarget(edge)
				if (plain_coloring == false):
					var edge_gradient
					var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
					if (edge_quantile_nr == max_quantile_nr-1):
						edge_gradient = edge_gradients[max_quantile_nr-2]
					else:
						edge_gradient = edge_gradients[edge_quantile_nr-1]
					var gradient_color = edge_gradient.interpolate(gvis_obj.graph_get_edge_lengths_quartile_pct(edge))
					new_colors.push_back(gradient_color)
					new_colors.push_back(gradient_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, gradient_color)
					GlobalVariables.edge_colors[edge] = gradient_color
				else:
					var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
					if (edge_quantile_nr == max_quantile_nr-1):
						edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
					elif (edge_quantile_nr == 0):
						edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr]]
					else:
						edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
					new_colors.push_back(edge_color)
					new_colors.push_back(edge_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, edge_color)
					GlobalVariables.edge_colors[edge] = edge_color
		arrays[ArrayMesh.ARRAY_COLOR] = new_colors
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		_change_edge_mesh_edge_size(curr_triangle_strip_width)

func _change_edge_mesh_edge_size(width):
	arrow_multi_mesh = arrow_multi_mesh_instance.multimesh
	arrow_multi_mesh.mesh = arrow_mesh_instance.mesh
	arrow_multi_mesh.instance_count = gvis_obj.graph_number_of_edges()
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9)
	var target_degree_size
	var curr_edge_color
	#safety check
	if (GlobalVariables.edge_quantiles_coloring == true):
		_init_gradients()
	if (arrays.size() > 0):
		if (triangle_strip == false):
			node_positions = []
			var vertices = PoolVector2Array()
			var colors = PoolColorArray()
			var nodes = 0
			var edges = 0
			var counter = 0
			var max_quantile_nr = GlobalVariables.probs.size()
			var node_x
			var node_y
			var target_x
			var target_y
			for node in range(gvis_obj.graph_number_of_nodes()):
				node_x = gvis_obj.graph_getX(node)
				node_y = gvis_obj.graph_getY(node)
				nodes += 1
				node_positions_in_array.push_back(counter)
				node_positions.push_back(Vector2(node_x, node_y))
				var target
				for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
					target = gvis_obj.graph_getEdgeTarget(edge)
					target_x = gvis_obj.graph_getX(target)
					target_y = gvis_obj.graph_getY(target)
					#gradient quantile coloring:
					if (GlobalVariables.edge_quantiles_coloring == true):
						#quantile gradient coloring
						if (GlobalVariables.plain_coloring == false):
							var edge_gradient
							var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
							if (edge_quantile_nr == max_quantile_nr-1):
								edge_gradient = edge_gradients[max_quantile_nr-2]
							else:
								edge_gradient = edge_gradients[edge_quantile_nr-1]
							var gradient_color = edge_gradient.interpolate(gvis_obj.graph_get_edge_lengths_quartile_pct(edge))
							gradient_color.a = edge_alpha
							colors.push_back(gradient_color)
							colors.push_back(gradient_color)
							arrow_multi_mesh_instance.multimesh.set_instance_color(edge, gradient_color)
						#plain quantile coloring
						else:
							var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
							if (edge_quantile_nr == max_quantile_nr-1):
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
							elif (edge_quantile_nr == 0):
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr]]
							else:
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
							edge_color.a = edge_alpha
							colors.push_back(edge_color)
							colors.push_back(edge_color)
							arrow_multi_mesh_instance.multimesh.set_instance_color(edge, edge_color)
							GlobalVariables.edge_colors[edge] = edge_color
					#plain color coloring
					else:
						vertices.push_back(Vector2(node_x, node_y))
						curr_edge_color = GlobalVariables.edge_colors[edge]
						colors.push_back(curr_edge_color)
						counter += 1
						vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target)))
						colors.push_back(curr_edge_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, curr_edge_color)
						edges += 1
						counter+= 1
					var node_sprite_degree_size
					if (GlobalVariables.degrees_node_sizing):
						target_degree_size = GlobalVariables.degrees_with_sizes[gvis_obj.graph_getNodeDegree(target)]
						node_sprite_degree_size = node_sprite_size * target_degree_size
					else:
						target_degree_size = node_size
						node_sprite_degree_size = node_sprite_size * target_degree_size
					
					var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
					var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
					var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
					var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_degree_size/2))
					
					arrow_size = 0.001
					target_transform.x *= arrow_size
					target_transform.y *= arrow_size
					
					arrow_multi_mesh.set_instance_transform_2d(edge, target_transform)
			
			arrays[ArrayMesh.ARRAY_VERTEX] = edge_vertices
			arrays[ArrayMesh.ARRAY_COLOR] = colors
			#save edge color
			edge_colors = colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
			GlobalVariables.edge_size = 0.02
		#edge thickness true
		else:
			#edge thickness triangle strip first true
			var vertices = PoolVector2Array()
			var colors = PoolColorArray()
			var max_quantile_nr = GlobalVariables.probs.size()
			
			var node_x
			var node_y
			var target_x
			var target_y
			
			for node in range(gvis_obj.graph_number_of_nodes()):
				var target
				node_x = gvis_obj.graph_getX(node)
				node_y = gvis_obj.graph_getY(node)
				for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
					target = gvis_obj.graph_getEdgeTarget(edge)
					target_x = gvis_obj.graph_getX(target)
					target_y = gvis_obj.graph_getY(target)
					
					var vector_norm1 = Vector2(target_x-node_x, target_y-node_y).normalized()
					var vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*width
					
					#gradient quantile coloring:
					if (GlobalVariables.edge_quantiles_coloring == true):
						#quantile gradient coloring
						if (GlobalVariables.plain_coloring == false):
							var edge_gradient
							var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
							if (edge_quantile_nr == max_quantile_nr-1):
								edge_gradient = edge_gradients[max_quantile_nr-2]
							else:
								edge_gradient = edge_gradients[edge_quantile_nr-1]
							
							var gradient_color = edge_gradient.interpolate(gvis_obj.graph_get_edge_lengths_quartile_pct(edge))
							gradient_color.a = edge_alpha
							
							vertices.push_back(Vector2(node_x, node_y)+vector_norm)
							colors.push_back(gradient_color)
							vertices.push_back(Vector2(node_x, node_y)-vector_norm)
							colors.push_back(gradient_color)
							vertices.push_back(Vector2(target_x, target_y)+vector_norm)
							colors.push_back(gradient_color)
							vertices.push_back(Vector2(target_x, target_y)+vector_norm)
							colors.push_back(gradient_color)
							vertices.push_back(Vector2(target_x, target_y)-vector_norm)
							colors.push_back(gradient_color)
							vertices.push_back(Vector2(node_x, node_y)-vector_norm)
							colors.push_back(gradient_color)
							arrow_multi_mesh_instance.multimesh.set_instance_color(edge, gradient_color)
							
						#plain quantile coloring
						else:
							var edge_quantile_nr = gvis_obj.graph_get_edge_quartile_nr(edge)
							if (edge_quantile_nr == max_quantile_nr-1):
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
							elif (edge_quantile_nr == 0):
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr]]
							else:
								edge_color = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.probs[edge_quantile_nr-1]]
							edge_color.a = edge_alpha
							vertices.push_back(Vector2(node_x, node_y)+vector_norm)
							colors.push_back(edge_color)
							vertices.push_back(Vector2(node_x, node_y)-vector_norm)
							colors.push_back(edge_color)
							vertices.push_back(Vector2(target_x, target_y)+vector_norm)
							colors.push_back(edge_color)
							vertices.push_back(Vector2(target_x, target_y)+vector_norm)
							colors.push_back(edge_color)
							vertices.push_back(Vector2(target_x, target_y)-vector_norm)
							colors.push_back(edge_color)
							vertices.push_back(Vector2(node_x, node_y)-vector_norm)
							colors.push_back(edge_color)
							arrow_multi_mesh_instance.multimesh.set_instance_color(edge, edge_color)
							GlobalVariables.edge_colors[edge] = edge_color
					#plain color coloring
					else:
						curr_edge_color = GlobalVariables.edge_colors[edge]
						vertices.push_back(Vector2(node_x, node_y)+vector_norm)
						colors.push_back(curr_edge_color)
						vertices.push_back(Vector2(node_x, node_y)-vector_norm)
						colors.push_back(curr_edge_color)
						vertices.push_back(Vector2(target_x, target_y)+vector_norm)
						colors.push_back(curr_edge_color)
						vertices.push_back(Vector2(target_x, target_y)+vector_norm)
						colors.push_back(curr_edge_color)
						vertices.push_back(Vector2(target_x, target_y)-vector_norm)
						colors.push_back(curr_edge_color)
						vertices.push_back(Vector2(node_x, node_y)-vector_norm)
						colors.push_back(curr_edge_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, curr_edge_color)
					var node_sprite_degree_size
					if (GlobalVariables.degrees_node_sizing):
						target_degree_size = GlobalVariables.degrees_with_sizes[gvis_obj.graph_getNodeDegree(target)]
						node_sprite_degree_size = node_sprite_size * target_degree_size
					else:
						target_degree_size = node_size
						node_sprite_degree_size = node_sprite_size * target_degree_size
					
					var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
					var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
					var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
					var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_degree_size/2))
					
					arrow_size = width*0.02
					target_transform.x *= arrow_size
					target_transform.y *= arrow_size
					
					arrow_multi_mesh.set_instance_transform_2d(edge, target_transform)
			
			arrays[ArrayMesh.ARRAY_VERTEX] = vertices
			arrays[ArrayMesh.ARRAY_COLOR] = colors
			edge_colors = colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
			GlobalVariables.edge_size = width/5

#gradients:

func _init_gradients():
	edge_gradients =  []
	GlobalVariables.probs = GlobalVariables.edge_gradients_quantiles_list
	for quantile_nr in range(GlobalVariables.edge_gradients_quantiles_list.size()-1):
		var current_gradient = Gradient.new()
		current_gradient.set_color(0, GlobalVariables.edge_gradients_with_colors[GlobalVariables.probs[quantile_nr]])
		current_gradient.set_color(1, GlobalVariables.edge_gradients_with_colors[GlobalVariables.probs[quantile_nr+1]])
		edge_gradients.push_back(current_gradient)
	gvis_obj.graph_init_edge_length_quartile_arrays(GlobalVariables.probs)
	GlobalVariables.gradients_changed = true

func _draw_graph_mesh(gvis_obj):

	node_multi_mesh = node_multi_mesh_instance.multimesh
	node_multi_mesh.mesh = node_mesh_instance.mesh
	node_multi_mesh.instance_count = gvis_obj.graph_number_of_nodes()
	
	arrow_multi_mesh = arrow_multi_mesh_instance.multimesh
	arrow_multi_mesh.mesh = arrow_mesh_instance.mesh
	arrow_multi_mesh.instance_count = gvis_obj.graph_number_of_edges()

	node_positions = []
	var vertices = PoolVector2Array()
	var colors = PoolColorArray()
	var nodes = 0
	var edges = 0
	var counter = 0
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9) * node_size
	var arrow_sprite_size = $ArrowSprite.texture.get_size() * arrow_size
	var node_x
	var node_y
	var target_x
	var target_y
	for node in range(gvis_obj.graph_number_of_nodes()):
		node_x = gvis_obj.graph_getX(node)
		node_y = gvis_obj.graph_getY(node)
		var node_transform = Transform2D( deg2rad(90), Vector2(node_x, node_y))
		node_transform.x *= node_size
		node_transform.y *= node_size
		node_multi_mesh.set_instance_transform_2d(node, node_transform)
		
		nodes += 1
		node_positions_in_array.push_back(counter)
		node_positions.push_back(Vector2(node_x, node_y))
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			target_x = gvis_obj.graph_getX(target)
			target_y = gvis_obj.graph_getY(target)
			var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
			var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
			var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
			var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_size/2))
			target_transform.x *= arrow_size
			target_transform.y *= arrow_size
			arrow_multi_mesh.set_instance_transform_2d(edge, target_transform)
			vertices.push_back(Vector2(node_x, node_y))
			colors.push_back(edge_color)
			counter += 1
			vertices.push_back(Vector2(target_x, target_y))
			colors.push_back(edge_color)
			edges += 1
			counter+= 1
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	edge_vertices = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	#save edge color
	edge_colors = colors
	# Create the Mesh.
	arr_mesh.surface_remove(0)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	edge_mesh_instance.mesh = arr_mesh
	GlobalVariables.node_multi_mesh_instance = node_multi_mesh_instance
	return node_positions

func _draw_graph_mesh_triangle_strip(gvis_obj, color1, color2, color3, color4, width):
	var node_multi_mesh = node_multi_mesh_instance.multimesh
	node_multi_mesh.mesh = node_mesh_instance.mesh
	node_multi_mesh.instance_count = gvis_obj.graph_number_of_nodes()

	node_positions = []
	var vertices = PoolVector2Array()
	var colors = PoolColorArray()

	var nodes = 0
	var edges = 0

	var counter = 0
	for node in range(gvis_obj.graph_number_of_nodes()):

		var node_transform = Transform2D( 2.0, Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		node_transform.x *= 0.01
		node_transform.y *= 0.01
		node_multi_mesh.set_instance_transform_2d(node, node_transform)
		nodes += 1
		node_positions_in_array.push_back(counter)
		node_positions.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		var target
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			var vector_norm1 = Vector2(gvis_obj.graph_getX(target)-gvis_obj.graph_getX(node), gvis_obj.graph_getY(target)-gvis_obj.graph_getY(node)).normalized()
			var vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*width
			vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))+vector_norm)
			colors.push_back(color1)
			vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(color1)
			vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(color1)
			vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(color2)
			vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))-vector_norm)
			colors.push_back(color2)
			vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(color2)
			edges += 1
			counter+= 1


	var curr_arr_mesh = ArrayMesh.new()
	var curr_arrays = []
	curr_arrays.resize(ArrayMesh.ARRAY_MAX)
	curr_arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	curr_arrays[ArrayMesh.ARRAY_COLOR] = colors

	curr_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, curr_arrays)

	edge_mesh_instance.mesh = curr_arr_mesh
	arr_mesh = curr_arr_mesh
	arrays = curr_arrays
	return node_positions
	
func _change_vertex_color(vertices, color):
	var curr_arrays = arrays
	var new_array_mesh = ArrayMesh.new()
	var target
	for node in vertices:
		arrays[ArrayMesh.ARRAY_COLOR][node_positions_in_array[node]] = color
	arr_mesh.surface_remove(0)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)

func _redraw_edge_mesh(gvis_obj, vertices, colors):
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

func _draw_new_mesh(gvis_obj,selected_vertices, selected_color):
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
	edge_mesh_instance.mesh = curr_arr_mesh
	pass
	
func _draw_path(gvis_obj, selected_nodes, node_color, edge_color, num_of_neighbors):
	
	var path_node_multi_mesh = path_multi_mesh_instance.multimesh
	path_node_multi_mesh.mesh = node_mesh_instance.mesh
	path_node_multi_mesh.instance_count = selected_nodes.size()
	path_multi_mesh_instance.self_modulate = node_color
	
	var arrow_border_node_multi_mesh = arrow_border_multi_mesh_instance.multimesh
	arrow_border_node_multi_mesh.mesh = arrow_mesh_instance.mesh
	arrow_border_multi_mesh_instance.self_modulate = edge_color
	
	node_positions = []
	var path_vertices = PoolVector2Array()
	var colors = PoolColorArray()

	var nodes = 0
	var edges = 0

	var counter = 0
	
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9)
	var target_degree_size
	
	var node_x
	var node_y
	var node_transform
	
	for node in selected_nodes:
		node_transform = node_multi_mesh_instance.multimesh.get_instance_transform_2d(node)
		path_node_multi_mesh.set_instance_transform_2d(0, node_transform)
		node_positions_in_array.push_back(counter)
		node_positions.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		var target
		num_of_neighbors.push_back(0)
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			var vector_norm1 = Vector2(gvis_obj.graph_getX(target)-gvis_obj.graph_getX(node), gvis_obj.graph_getY(target)-gvis_obj.graph_getY(node)).normalized()
			var vector_norm
			if (GlobalVariables.edge_size == 0.02):
				vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*GlobalVariables.edge_size*2*GlobalVariables.current_zoom_level*30
			else:
				vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*GlobalVariables.edge_size*2*clamp(GlobalVariables.current_zoom_level*10, 2.5, 4)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))-vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(edge_color)
			edges += 1
			counter+= 1
			num_of_neighbors[nodes] += 1
		arrow_border_node_multi_mesh.instance_count = num_of_neighbors[nodes]
		var target_x
		var target_y
		node_x = gvis_obj.graph_getX(node)
		node_y = gvis_obj.graph_getY(node)
		edges = 0
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			target_x = gvis_obj.graph_getX(target)
			target_y = gvis_obj.graph_getY(target)
			var node_sprite_degree_size
			if (GlobalVariables.degrees_node_sizing):
				target_degree_size = GlobalVariables.degrees_with_sizes[gvis_obj.graph_getNodeDegree(target)]
				node_sprite_degree_size = node_sprite_size * target_degree_size
			else:
				target_degree_size = node_size
				node_sprite_degree_size = node_sprite_size * target_degree_size
			var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
			var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
			var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
			var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_degree_size/2))
			
			target_transform.x *= arrow_size
			target_transform.y *= arrow_size
			
			arrow_border_node_multi_mesh.set_instance_transform_2d(edges, target_transform)
			edges += 1
		nodes += 1

	path_arrays.resize(ArrayMesh.ARRAY_MAX)
	path_arrays[ArrayMesh.ARRAY_VERTEX] = path_vertices
	path_arrays[ArrayMesh.ARRAY_COLOR] = colors
	
	path_arr_mesh.surface_remove(0)
	path_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, path_arrays)

	path_mesh_instance.mesh = path_arr_mesh
	return node_positions

func _draw_path2(gvis_obj, selected_nodes, node_color, edge_color, num_of_neighbors):
	
	var path_node_multi_mesh = selection_multi_mesh_instance.multimesh
	path_node_multi_mesh.mesh = node_mesh_instance.mesh
	path_node_multi_mesh.instance_count = selected_nodes.size()
	selection_multi_mesh_instance.self_modulate = node_color
	var arrow_border_node_multi_mesh = arrow_border_multi_mesh_instance2.multimesh
	arrow_border_node_multi_mesh.mesh = arrow_mesh_instance2.mesh
	arrow_border_multi_mesh_instance2.self_modulate = edge_color
	
	node_positions = []
	var path_vertices = PoolVector2Array()
	var colors = PoolColorArray()
	var nodes = 0
	var edges = 0
	var counter = 0
	var node_sprite_size = ($NodeSprite2.texture.get_size() / 3.9) * node_size
	var node_x
	var node_y
	var node_transform
	
	for node in selected_nodes:
		node_transform = node_multi_mesh_instance.multimesh.get_instance_transform_2d(node)
		path_node_multi_mesh.set_instance_transform_2d(0, node_transform)
		node_positions_in_array.push_back(counter)
		node_positions.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node)))
		var target
		num_of_neighbors.push_back(0)
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			var vector_norm1 = Vector2(gvis_obj.graph_getX(target)-gvis_obj.graph_getX(node), gvis_obj.graph_getY(target)-gvis_obj.graph_getY(node)).normalized()
			var vector_norm
			if (GlobalVariables.edge_size == 0.02):
				vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*GlobalVariables.edge_size*2*GlobalVariables.current_zoom_level*30
			else:
				vector_norm = Vector2(-vector_norm1.y, vector_norm1.x)*GlobalVariables.edge_size*2*clamp(GlobalVariables.current_zoom_level*10, 2.5, 4)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))+vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(target), gvis_obj.graph_getY(target))-vector_norm)
			colors.push_back(edge_color)
			path_vertices.push_back(Vector2(gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))-vector_norm)
			colors.push_back(edge_color)
			edges += 1
			counter+= 1
			num_of_neighbors[nodes] += 1
		arrow_border_node_multi_mesh.instance_count = num_of_neighbors[nodes]
		var target_x
		var target_y
		node_x = gvis_obj.graph_getX(node)
		node_y = gvis_obj.graph_getY(node)
		edges = 0
		for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
			target = gvis_obj.graph_getEdgeTarget(edge)
			target_x = gvis_obj.graph_getX(target)
			target_y = gvis_obj.graph_getY(target)
			var direction_vector = Vector2(target_x, target_y).direction_to(Vector2(node_x, node_y))
			var direction_angle = Vector2(target_x, target_y).angle_to_point(Vector2(node_x, node_y))
			var edge_distance = Vector2(target_x, target_y).distance_to(Vector2(node_x, node_y))
			var target_transform = Transform2D(direction_angle + deg2rad(90), Vector2(target_x, target_y) + direction_vector*(node_sprite_size/2))
			
			target_transform.x *= arrow_size
			target_transform.y *= arrow_size
			
			arrow_border_node_multi_mesh.set_instance_transform_2d(edges, target_transform)
			edges += 1
		nodes += 1

	selection_arrays.resize(ArrayMesh.ARRAY_MAX)
	selection_arrays[ArrayMesh.ARRAY_VERTEX] = path_vertices
	selection_arrays[ArrayMesh.ARRAY_COLOR] = colors
	
	selection_arr_mesh.surface_remove(0)
	selection_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, selection_arrays)

	selection_mesh_instance.mesh = selection_arr_mesh
	return node_positions

func _on_node_partition_colors_change_applied():
	_change_node_mesh_color_partition()

func _change_node_mesh_color_partition():
	var partition_color
	for node in range(gvis_obj.graph_number_of_nodes()):
		partition_color = GlobalVariables.partitions_with_colors[gvis_obj.graph_getPartitionIndex(node)]
		node_multi_mesh_instance.multimesh.set_instance_color(node, partition_color)
		GlobalVariables.node_colors[node] = partition_color

func _on_edge_partition_colors_change_applied():
	_change_edge_mesh_color_partition()

func _change_edge_mesh_color_partition():
	if (triangle_strip == false):
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			for node in range(gvis_obj.graph_number_of_nodes()):
				var target
				for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
					target = gvis_obj.graph_getEdgeTarget(edge)
					var part_color
					if (gvis_obj.graph_getPartitionIndex(node) != gvis_obj.graph_getPartitionIndex(target)):
						part_color = GlobalVariables.partitions_edge_color
						new_colors.push_back(part_color)
						new_colors.push_back(part_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
					else:
						part_color = GlobalVariables.partitions_with_colors[gvis_obj.graph_getPartitionIndex(node)]
						new_colors.push_back(part_color)
						new_colors.push_back(part_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
					GlobalVariables.edge_colors[edge] = part_color
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	else:
		var new_colors = PoolColorArray()
		for node in range(gvis_obj.graph_number_of_nodes()):
			var target
			for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
				target = gvis_obj.graph_getEdgeTarget(edge)
				var part_color
				if (gvis_obj.graph_getPartitionIndex(node) != gvis_obj.graph_getPartitionIndex(target)):
					part_color = GlobalVariables.partitions_edge_color
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
				else:
					part_color = GlobalVariables.partitions_with_colors[gvis_obj.graph_getPartitionIndex(node)]
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
				GlobalVariables.edge_colors[edge] = part_color
		arrays[ArrayMesh.ARRAY_COLOR] = new_colors
		arr_mesh.surface_remove(0)
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

func _on_node_vertex_set_colors_change_applied():
	_change_node_mesh_color_vertex_set()

func _change_node_mesh_color_vertex_set():
	var vertex_set_color
	for node in range(gvis_obj.graph_number_of_nodes()):
		vertex_set_color = GlobalVariables.vertex_sets_with_colors[gvis_obj.graph_getVertexSetIndex(node)]
		node_multi_mesh_instance.multimesh.set_instance_color(node, vertex_set_color)
		GlobalVariables.node_colors[node] = vertex_set_color

func _on_edge_vertex_set_colors_change_applied():
	_change_edge_mesh_color_vertex_set()

func _change_edge_mesh_color_vertex_set():
	if (triangle_strip == false):
		var new_arr_mesh = ArrayMesh.new()
		var new_arrays = arrays.duplicate(true)
		if (arrays.size() > 0):
			var new_colors = PoolColorArray()
			for node in range(gvis_obj.graph_number_of_nodes()):
				var target
				for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
					target = gvis_obj.graph_getEdgeTarget(edge)
					var part_color
					if (gvis_obj.graph_getVertexSetIndex(node) != gvis_obj.graph_getVertexSetIndex(target)):
						part_color = GlobalVariables.vertex_sets_edge_color
						new_colors.push_back(part_color)
						new_colors.push_back(part_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
					else:
						part_color = GlobalVariables.vertex_sets_with_colors[gvis_obj.graph_getVertexSetIndex(node)]
						new_colors.push_back(part_color)
						new_colors.push_back(part_color)
						arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
					GlobalVariables.edge_colors[edge] = part_color
			arrays[ArrayMesh.ARRAY_COLOR] = new_colors
			arr_mesh.surface_remove(0)
			arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	else:
		var new_arr_mesh = ArrayMesh.new()
		var new_arrays = triangle_strip_arrays.duplicate(true)
		var new_colors = PoolColorArray()
		for node in range(gvis_obj.graph_number_of_nodes()):
			var target
			for edge in range(gvis_obj.graph_get_first_edge(node), gvis_obj.graph_get_first_invalid_edge(node)):
				target = gvis_obj.graph_getEdgeTarget(edge)
				var part_color
				if (gvis_obj.graph_getVertexSetIndex(node) != gvis_obj.graph_getVertexSetIndex(target)):
					part_color = GlobalVariables.vertex_sets_edge_color
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
				else:
					part_color = GlobalVariables.vertex_sets_with_colors[gvis_obj.graph_getVertexSetIndex(node)]
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					new_colors.push_back(part_color)
					arrow_multi_mesh_instance.multimesh.set_instance_color(edge, part_color)
				GlobalVariables.edge_colors[edge] = part_color
		arrays[ArrayMesh.ARRAY_COLOR] = new_colors
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
