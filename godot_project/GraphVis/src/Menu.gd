extends Control

var graph_file

onready var gvis_obj = GlobalVariables.gvis_obj

onready var file_menu_button = $"Panel/HBoxContainer/FileMenuButton"
onready var draw_menu_button = $"Panel/HBoxContainer/DrawMenuButton"

func _ready():
	file_menu_button.get_popup().connect("id_pressed", self, "_on_file_item_pressed")
	draw_menu_button.get_popup().connect("id_pressed", self, "_on_draw_item_pressed")
	
func _on_file_item_pressed(id):
	var item_name = file_menu_button.get_popup().get_item_text(id)
	if item_name == "Open Graph File":
		file_menu_button.get_node("OpenGraphFileDialog").popup()
	if item_name == "Open Graph Configuration Folder":
		file_menu_button.get_node("OpenGraphConfigDialog").popup()
		
func _on_draw_item_pressed(id):
	var item_name = draw_menu_button.get_popup().get_item_text(id)
	if item_name == "Draw From KaDraw Coords":
		draw_menu_button.get_node("DrawFromKaDrawCoordsFileDialog").popup()

func _on_OpenFileDialog_file_selected(path):
	GlobalVariables.gvis_obj.graph_read_file(path)
	get_tree().get_root().get_node("Main/CanvasLayer/GraphInfo/Panel/Label").text = ("Graph: " + str(path.get_file()) +
																					 "   #Nodes: " + str(gvis_obj.graph_number_of_nodes()) +
																					 "   #Edges: " + str(gvis_obj.graph_number_of_edges()))
	if get_tree().get_root().get_node("Main").active_path_meshes.size()>=1:
		get_tree().get_root().get_node("Main").active_path_meshes[-1].queue_free()
		get_tree().get_root().get_node("Main").active_path_meshes.pop_back()
	
	GlobalSettings.reset_option_changes()

func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path,2) #2 = write only flag

func _on_OpenCoordFileDialog_file_selected(path):
	var gvis_obj = get_tree().get_root().get_node("Main").get("gvis")
	
	for node in range(gvis_obj.graph_number_of_nodes()):
		gvis_obj.graph_setCoords(node, gvis_obj.graph_getX(node), gvis_obj.graph_getY(node))

func _on_SaveCoordFileDialog_file_selected(path):
	pass # Replace with function body.

func _on_DrawFromKaDrawCoordsFileDialog_file_selected(path):
	GlobalVariables.gvis_obj.graph_set_kadraw_coords(path, 20)
	var shift_x = OS.get_window_size().x/4
	var shift_y = OS.get_window_size().y/4
	gvis_obj.ui_set_window_x(OS.get_window_size().x*.5)
	gvis_obj.ui_set_window_y(OS.get_window_size().y*.5)
	for node in range(gvis_obj.graph_number_of_nodes()):
		gvis_obj.graph_setCoords(node, GlobalVariables.gvis_obj.graph_getX(node) -shift_x, GlobalVariables.gvis_obj.graph_getY(node) -shift_y)
	gvis_obj.graph_init_edge_length_array()
	get_tree().get_root().get_node("Main").draw_graph_mesh()
	GlobalVariables.node_positions = GlobalVariables.graph_mesh._draw_graph_mesh(gvis_obj)
	get_tree().get_root().get_node("Main/CameraCanvas/CameraZoom").position = Vector2(0,0)

func _on_OpenGraphConfigDialog_dir_selected(dir: String) -> void:
	var files_list = []
	var directory = Directory.new()
	directory.open(dir)
	directory.list_dir_begin()
	
	var first_graph = false
	var first_coord = false
	var first_partition = false
	
	GlobalSettings.reset_option_changes()
	
	get_tree().reload_current_scene()
	
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
			if file_name.get_extension() == "partition" and first_partition == false:
				GlobalVariables.partition_name = dir + "/" + file_name
				first_partition = true
	directory.list_dir_end()
	#set graph:
	GlobalVariables.gvis_obj.graph_read_file(GlobalVariables.file_name)
	get_tree().get_root().get_node("Main/CanvasLayer/GraphInfo/Panel/Label").text = ("Graph: " + str(GlobalVariables.file_name.get_file()) +
																					 "   #Nodes: " + str(GlobalVariables.gvis_obj.graph_number_of_nodes()) +
																					 "   #Edges: " + str(GlobalVariables.gvis_obj.graph_number_of_edges()))
	if get_tree().get_root().get_node("Main").active_path_meshes.size()>=1:
		get_tree().get_root().get_node("Main").active_path_meshes[-1].queue_free()
		get_tree().get_root().get_node("Main").active_path_meshes.pop_back()
	GlobalVariables.gvis_obj.graph_set_kadraw_coords(GlobalVariables.coords_name, 500)
	for node in range(GlobalVariables.gvis_obj.graph_number_of_nodes()):
		GlobalVariables.gvis_obj.graph_setCoords(node, GlobalVariables.gvis_obj.graph_getX(node) -
												 get_tree().get_root().get_node("Main").shift_x,
												 GlobalVariables.gvis_obj.graph_getY(node) - get_tree().get_root().get_node("Main").shift_y)
	GlobalVariables.gvis_obj.graph_init_edge_length_array()
	GlobalVariables.gvis_obj.graph_init_edge_length_quartile_arrays([0.25, 0.5, .75])
	GlobalVariables.graph_mesh = GlobalVariables.GraphMeshResource.instance()
	get_tree().get_root().get_node("Main/MeshNode2D").add_child(GlobalVariables.graph_mesh)
	GlobalVariables.node_positions = GlobalVariables.graph_mesh._draw_graph_mesh(GlobalVariables.gvis_obj)
	get_tree().get_root().get_node("Main").active_meshes.push_back(GlobalVariables.graph_mesh)
	
	GlobalVariables.gvis_obj.graph_read_partition(GlobalVariables.partition_name)
	GlobalSettings.change_partitionid_list()
	
	GlobalVariables.graph_loaded = true
