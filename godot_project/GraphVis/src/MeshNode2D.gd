extends Node2D

onready var mouse_start_pos
onready var nearest_node
onready var nearest_node_dist
onready var shortest_dist_tresh

onready var path_node_mesh
onready var num_of_neighbors
onready var selected_node_pos
onready var posix
onready var posiy
onready var zoomi

onready var selection_node_mesh
onready var selection_node_nearest
onready var selection_node_neighbors
onready var selection_node_mesh_init = false

onready var info_box = false


func _input(event):
	if (GlobalVariables.graph_loaded):
		if (GlobalVariables.node_scanner):
			if(GlobalVariables.graph_moving == false):
				if event.is_action("left_click"):
					if (info_box == false):
						mouse_start_pos = get_local_mouse_position()
						nearest_node = get_tree().get_root().get_node("Main").find_closest_node(mouse_start_pos, GlobalVariables.node_positions)[0]
						nearest_node_dist = get_tree().get_root().get_node("Main").find_closest_node(mouse_start_pos, GlobalVariables.node_positions)[1]
						posix = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom").get_global_mouse_position().x
						posiy = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom").get_global_mouse_position().y
						zoomi = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom")._zoom_level
						get_tree().get_root().get_node("Main/NodeInfo/NodeInfoPanel").rect_position = Vector2(posix, posiy)
						shortest_dist_tresh = 5
						if (nearest_node_dist < shortest_dist_tresh):
							num_of_neighbors = []
							get_tree().get_root().get_node("Main").node_id.text = str(nearest_node)
							if (num_of_neighbors.size() > 0):
								get_tree().get_root().get_node("Main").node_num_of_neighbors.text = str(num_of_neighbors[0])
							selection_node_mesh = GlobalVariables.graph_mesh
							add_child(selection_node_mesh)
							selection_node_nearest = nearest_node
							selection_node_neighbors = num_of_neighbors.duplicate(true)
							selection_node_mesh_init = true
							get_tree().get_root().get_node("Main").node_info_panel.visible = true
							GlobalVariables.graph_mesh.selection_multi_mesh_instance.visible = true
							GlobalVariables.graph_mesh.selection_mesh_instance.visible = true
						else:
							GlobalVariables.graph_mesh.selection_multi_mesh_instance.visible = false
							GlobalVariables.graph_mesh.selection_mesh_instance.visible = false
							selection_node_mesh_init = false
						if event.doubleclick:
							if (nearest_node_dist >= shortest_dist_tresh):
								get_tree().get_root().get_node("Main").node_info_panel.visible = false
					

func _process(delta: float) -> void:
	if (GlobalVariables.graph_loaded):
		if (GlobalVariables.graph_moving == false):
			if(selection_node_mesh_init or GlobalVariables.node_scanner or (get_tree().get_root().get_node("Main").node_info_panel.visible == true)):
				mouse_start_pos = get_global_mouse_position()
				mouse_start_pos = get_local_mouse_position()
				nearest_node = get_tree().get_root().get_node("Main").find_closest_node(mouse_start_pos, GlobalVariables.node_positions)[0]
				nearest_node_dist = get_tree().get_root().get_node("Main").find_closest_node(mouse_start_pos, GlobalVariables.node_positions)[1]
				shortest_dist_tresh = 10
				posix = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom").get_global_mouse_position().x
				posiy = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom").get_global_mouse_position().y
				zoomi = get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom")._zoom_level
				get_tree().get_root().get_node("Main/NodeInfo/NodeInfoPanel").rect_position = Vector2(posix, posiy)
				if selection_node_mesh_init:
					selection_node_neighbors = []
					selection_node_mesh._draw_path2(get_tree().get_root().get_node("Main").gvis, [selection_node_nearest],
												   GlobalVariables.node_selection_node_color,
												   GlobalVariables.node_selection_edge_color, selection_node_neighbors)
				if (nearest_node_dist < shortest_dist_tresh):
					if(GlobalVariables.node_scanner):
						selection_node_mesh = GlobalVariables.graph_mesh
						num_of_neighbors = []
						selected_node_pos = selection_node_mesh._draw_path(get_tree().get_root().get_node("Main").gvis,
																	 [nearest_node], GlobalVariables.node_scanner_color,
																	 GlobalVariables.node_scanner_color, num_of_neighbors)
					if (get_tree().get_root().get_node("Main").node_info_panel.visible == true):
						get_tree().get_root().get_node("Main").node_id.text = str(nearest_node)
						get_tree().get_root().get_node("Main").node_num_of_neighbors.text = str(GlobalVariables.gvis_obj.graph_getNodeDegree(nearest_node))
						if (GlobalVariables.partition_loaded):
							get_tree().get_root().get_node("Main").node_partition_id.text = str(GlobalVariables.gvis_obj.graph_getPartitionIndex(nearest_node))
						else:
							get_tree().get_root().get_node("Main").node_partition_id.text = "-"
						if (GlobalVariables.vertexset_loaded):
							get_tree().get_root().get_node("Main").node_vertexset_id.text = str(GlobalVariables.gvis_obj.graph_getVertexSetIndex(nearest_node))
						else:
							get_tree().get_root().get_node("Main").node_vertexset_id.text = "-"
					update()
					GlobalVariables.graph_mesh.path_multi_mesh_instance.visible = true
					GlobalVariables.graph_mesh.path_mesh_instance.visible = true
				elif(nearest_node_dist >= shortest_dist_tresh):
					GlobalVariables.graph_mesh.path_multi_mesh_instance.visible = false
					GlobalVariables.graph_mesh.path_mesh_instance.visible = false
					get_tree().get_root().get_node("Main").node_id.text = "-"
					get_tree().get_root().get_node("Main").node_num_of_neighbors.text = "-"
					get_tree().get_root().get_node("Main").node_partition_id.text = "-"
					get_tree().get_root().get_node("Main").node_vertexset_id.text = "-"
