extends Node2D


onready var options_menu = $CanvasLayer/OptionsMenu

var current_dir
var path 
var file_name
var coords_name
var partition_name
var vertex_name

onready var gvis = GRAPHVIS.new()


var rng = RandomNumberGenerator.new()

var window_size = OS.get_window_size()

var shift_x = OS.get_window_size().x/4
var shift_y = OS.get_window_size().y/4

var k_test

#graphmesh scene
const GraphMeshResource = preload("res://GraphMesh.tscn")
const GraphMeshResourceNodeScanner = preload("res://GraphMesh.tscn")
const GraphMeshResourceNodeSelection = preload("res://GraphMesh.tscn")


onready var active_meshes = []
onready var active_temp_meshes = []
onready var active_path_meshes = []
onready var active_selection_meshes = []

var mouse_start_pos

#nodeInfo:
onready var node_info_panel = $"NodeInfo/NodeInfoPanel"
onready var node_id = $"NodeInfo/NodeInfoPanel/MarginContainer/GridContainer/NodeID"
onready var node_num_of_neighbors = $"NodeInfo/NodeInfoPanel/MarginContainer/GridContainer/NumberOfNeighbors"
onready var node_partition_id = $"NodeInfo/NodeInfoPanel/MarginContainer/GridContainer/PartitionID"
onready var node_vertexset_id = $"NodeInfo/NodeInfoPanel/MarginContainer/GridContainer/VertexSetID"

onready var graphmeshinstance

onready var options_button = $"CanvasLayer/Menu/Panel/HBoxContainer/OptionsButton"
onready var camera_button = $"CanvasLayer/Menu/Panel/HBoxContainer/CameraButton"

onready var mesh_viewport = $"MeshNode2D"

func _ready():
	GlobalSettings.connect("background_color_changed", self, "_on_background_color_changed")
	var viewport = Viewport.new()
	viewport.size = get_viewport_rect().size
	
	gvis.ui_set_window_x(OS.get_window_size().x*.5)
	gvis.ui_set_window_y(OS.get_window_size().y*.5)

	if GlobalVariables.first_start:
		GlobalVariables.first_start = false
	else:
		GlobalVariables.gvis_obj = gvis
		GlobalVariables.gvis_obj.graph_read_file(GlobalVariables.file_name)
		get_tree().get_root().get_node("Main/CanvasLayer/GraphInfo/Panel/Label").text = ("Graph: " + str(GlobalVariables.file_name.get_file()) +
																					 "   #Nodes: " + str(GlobalVariables.gvis_obj.graph_number_of_nodes()) +
																					 "   #Edges: " + str(GlobalVariables.gvis_obj.graph_number_of_edges()))
	
		GlobalVariables.gvis_obj.graph_set_kadraw_coords(GlobalVariables.coords_name, 500)
		for node in range(GlobalVariables.gvis_obj.graph_number_of_nodes()):
			GlobalVariables.gvis_obj.graph_setCoords(node, GlobalVariables.gvis_obj.graph_getX(node) -
													 get_tree().get_root().get_node("Main").shift_x,
													 GlobalVariables.gvis_obj.graph_getY(node) - get_tree().get_root().get_node("Main").shift_y)
			GlobalVariables.node_colors.push_back(Color(1,1,1,1))
			for edge in range(GlobalVariables.gvis_obj.graph_get_first_edge(node), GlobalVariables.gvis_obj.graph_get_first_invalid_edge(node)):
				GlobalVariables.edge_colors.push_back(Color(1,1,1,1))
		GlobalVariables.gvis_obj.graph_init_edge_length_array()
		GlobalVariables.gvis_obj.graph_init_edge_length_quartile_arrays([0.25, 0.5, .75])
		GlobalVariables.graph_mesh = GraphMeshResource.instance()
		$MeshNode2D.add_child(GlobalVariables.graph_mesh)
		GlobalVariables.node_positions = GlobalVariables.graph_mesh._draw_graph_mesh(GlobalVariables.gvis_obj)
		get_tree().get_root().get_node("Main").active_meshes.push_back(GlobalVariables.graph_mesh)
		if GlobalVariables.partition_loaded:
			GlobalVariables.gvis_obj.graph_read_partition(GlobalVariables.partition_name)
			GlobalSettings.change_partitionid_list()
		if GlobalVariables.vertexset_loaded:
			GlobalVariables.gvis_obj.graph_read_vertex_set(GlobalVariables.vertexset_name)
			GlobalSettings.change_vertexsetid_list()
		options_button.visible = true
		camera_button.visible = true
		
		GlobalVariables.graph_mesh2 = GraphMeshResource.instance()
		for node in range(GlobalVariables.gvis_obj.graph_number_of_nodes()):
			GlobalVariables.node_sizes.push_back(0.01)

func _on_background_color_changed(value):
	VisualServer.set_default_clear_color(value)

func draw_graph_mesh():
	if active_meshes.size()>=1:
		active_meshes[-1].queue_free()
		active_meshes.pop_back()
	if active_temp_meshes.size()>=1:
		active_temp_meshes[-1].queue_free()
		active_temp_meshes.pop_back()
	GlobalVariables.graph_mesh = GlobalVariables.GraphMeshResource.instance()
	GlobalVariables.graph_mesh.gvis_obj = gvis
	$MeshNode2D.add_child(GlobalVariables.graph_mesh)
	GlobalVariables.graph_mesh._draw_graph_mesh(gvis)
	active_meshes.push_back(GlobalVariables.graph_mesh)

func draw_graph_mesh_color_init():
	if active_meshes.size()>=1:
		active_meshes[-1].queue_free()
		active_meshes.pop_back()
	if active_temp_meshes.size()>=1:
		active_temp_meshes[-1].queue_free()
		active_temp_meshes.pop_back()
	GlobalVariables.graph_mesh = GlobalVariables.GraphMeshResource.instance()
	GlobalVariables.graph_mesh.gvis_obj = gvis
	$MeshNode2D.add_child(GlobalVariables.graph_mesh)
	GlobalVariables.graph_mesh._change_edge_mesh_color_gradients(Color(1,1,1,1))
	active_meshes.push_back(GlobalVariables.graph_mesh)

func find_closest_node(input_pos, cur_node_positions):
	var min_node = 0
	var distance = INF
	var shortest_distance = INF
	
	for node_index in cur_node_positions.size():
		distance = input_pos.distance_to(cur_node_positions[node_index])
		if distance < shortest_distance:
			shortest_distance = distance
			min_node = node_index
	return [min_node, shortest_distance]


func _on_kadraw_layout_button_pressed():
	gvis.ui_set_window_x(OS.get_window_size().x*.7)
	gvis.ui_set_window_y(OS.get_window_size().y)
	gvis.graph_set_kadraw_coords(coords_name)
	for node in range(gvis.graph_number_of_nodes()):
		gvis.graph_setCoords(node, gvis.graph_getX(node)+shift_x, gvis.graph_getY(node)+shift_y)
	draw_graph_mesh()

func _draw_new_mesh():
	if active_meshes.size()>=1:
		active_meshes[-1].queue_free()
		active_meshes.pop_back()
	if active_temp_meshes.size()>=1:
		active_temp_meshes[-1].queue_free()
		active_temp_meshes.pop_back()
	var graph_mesh_new = GlobalVariables.GraphMeshResource.instance()
	$MeshNode2D.add_child(graph_mesh_new)
	
	graph_mesh_new._draw_graph_mesh_triangle_strip(gvis, Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1) ),
													Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1) ),
													Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1) ),
													Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1) ),rng.randf_range(0, 10))
	active_temp_meshes.push_back(graph_mesh_new)

func _on_random_layout_button_pressed():
	rng.randomize()
	_draw_new_mesh()

func _on_OptionsButton_pressed():
	get_tree().get_root().get_node("Main").node_info_panel.visible = false
	options_menu.popup_centered()
	GlobalVariables.graph_moving = true

func _on_Area2D_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_HELP)

func _on_OptionsMenu_popup_hide() -> void:
	GlobalVariables.graph_moving = false
	
func test():
	var files_list = []
	var first_graph = false
	var first_coord = false
	var first_partition = false
	var first_vertexset = false
	var graph_file
	var coord_file
	GlobalSettings.reset_option_changes()
	GlobalVariables.graph_loaded = true
	GlobalVariables.file_name = "/home/wayfarer/Desktop/graphvis stuff/GraphVis_project/graphs/graph configs/3elt/3elt.graph"
	first_graph = true
	GlobalVariables.coords_name = "/home/wayfarer/Desktop/graphvis stuff/GraphVis_project/graphs/graph configs/3elt/3elt.coord"
	first_coord = true
	GlobalVariables.partition_name = "/home/wayfarer/Desktop/graphvis stuff/GraphVis_project/graphs/graph configs/3elt/3elt.prt"
	first_partition = true
	GlobalVariables.partition_loaded = true
	GlobalSettings.load_partition()
	get_tree().reload_current_scene()
	
func _on_OpenGraphConfigDialog_dir_selected(dir: String) -> void:
	get_tree().get_root().get_node("Main").node_info_panel.visible = false
	var files_list = []
	var directory = Directory.new()
	directory.open(dir)
	directory.list_dir_begin()
	var first_graph = false
	var first_coord = false
	var first_partition = false
	var first_vertexset = false
	var graph_file
	var coord_file
	GlobalSettings.reset_option_changes()
	GlobalVariables.graph_loaded = true
	
	while true:
		var file_name = directory.get_next()
		if file_name == "":
			break
		elif not file_name.begins_with("."):
			if file_name.get_extension() == "graph" and first_graph == false:
				GlobalVariables.file_name = dir + "/" + file_name
				first_graph = true
			if file_name.get_extension() == "coord" and first_coord == false:
				GlobalVariables.coords_name = dir + "/" + file_name
				first_coord = true
			if file_name.get_extension() == "prt" and first_partition == false:
				GlobalVariables.partition_name = dir + "/" + file_name
				first_partition = true
				GlobalVariables.partition_loaded = true
				GlobalSettings.load_partition()
			if file_name.get_extension() == "vs" and first_vertexset == false:
				GlobalVariables.vertexset_name = dir + "/" + file_name
				first_vertexset = true
				GlobalVariables.vertexset_loaded = true
				GlobalSettings.load_vertexset()
			
	directory.list_dir_end()
	
	get_tree().reload_current_scene()

func _on_FileMenuButton_pressed() -> void:
	get_tree().get_root().get_node("Main").node_info_panel.visible = false

func _on_CameraButton_pressed() -> void:
	get_tree().get_root().get_node("Main").node_info_panel.visible = false
	get_tree().get_root().set_transparent_background(true)
	$CanvasLayer/Menu.visible = false
	$CanvasLayer/GraphInfo.visible = false
	$NodeInfo/NodeInfoPanel.visible = false
	yield(get_tree().create_timer(1), "timeout")
	var my_img : Image =  get_tree().get_root().get_texture().get_data()
	my_img.convert(Image.FORMAT_RGBA8)
	my_img.flip_y()
	my_img.save_png(str(OS.get_executable_path().get_base_dir().plus_file(str(GlobalVariables.file_name.get_file().get_basename()))))
	get_tree().get_root().set_transparent_background(false)
	$CanvasLayer/Menu.visible = true
	$CanvasLayer/GraphInfo.visible = true
