extends Node

onready var gvis_obj

#file
onready var file_name
onready var coords_name
onready var partition_name
onready var vertexset_name

#options
onready var node_scanner = true
onready var node_scanner_color = Color(1,0,0,1)
onready var node_selection_node_color = Color(0,0,1,1)
onready var node_selection_edge_color = Color(0,0,1,1)

#positions
onready var node_positions = []

#Graph Mesh
onready var graph_mesh
onready var graph_mesh2

onready var quantiles_initialized = false

#graph mesh quantile gradient
onready var probs = []
onready var edge_quantiles_coloring = false
onready var edge_gradients_with_colors = {}
onready var edge_gradients_quantiles_list = []
onready var edge_gradients_colors = []

onready var edge_quantiles_with_colors = {}
onready var plain_coloring = false
onready var gradients_changed = false

onready var single_color = Color(1,1,1,1)

#node sizes
onready var degrees_with_sizes = {}
onready var degrees_node_sizing = false
onready var degrees_sizes_init = true
onready var max_node_size = 0.05
onready var node_sizes = []
onready var node_multi_mesh_instance
onready var node_border_multi_mesh_instance

#node colors
onready var node_colors = []

#edge colors
onready var edge_colors = []

#edgesizes
onready var edge_size = .02

#partitions
onready var partitions_with_colors = {}
onready var node_partition_coloring = false
onready var partitions_edge_color = Color(0,0,0,1)
onready var partitions_color_init = true

#vertex sets
onready var vertex_sets_with_colors = {}
onready var node_vertex_sets_coloring = false
onready var vertex_sets_edge_color = Color(0,0,0,1)
onready var vertex_sets_color_init = true

#Main Scene Nodes
onready var main_scene_control_node = get_node("/root/Main/Control")
onready var option_node

#misc
onready var random_generator = RandomNumberGenerator.new()
onready var graph_moving = false
onready var current_zoom_level = 1.0
onready var first_start = true
onready var graph_loaded = false
onready var partition_loaded = false
onready var vertexset_loaded = false

func _ready():
	edge_gradients_with_colors[float(0)] = Color(1,1,1,1)
	edge_gradients_with_colors[float(1)] = Color(0,0,0,1)
	edge_quantiles_with_colors[float(0)] = Color(1,1,1,1)
	edge_gradients_quantiles_list.push_back(float(0))
	edge_gradients_quantiles_list.push_back(float(1))
	GlobalSettings.connect("option_changes_reset", self, "_on_option_changes_reset")
	
func _on_option_changes_reset():
	#options
	node_scanner = true
	node_scanner_color = Color(1,0,0,1)
	node_selection_node_color = Color(0,0,1,1)
	node_selection_edge_color = Color(0,0,1,1)
	#positions
	node_positions = []
	#Graph Mesh
	quantiles_initialized = false
	#graph mesh quantile gradient
	probs = []
	edge_quantiles_coloring = false
	edge_gradients_with_colors = {}
	edge_gradients_quantiles_list = []
	edge_gradients_colors = []
	edge_quantiles_with_colors = {}
	plain_coloring = false
	gradients_changed = false
	single_color = Color(1,1,1,1)
	#node sizes
	degrees_with_sizes = {}
	degrees_node_sizing = false
	degrees_sizes_init = true
	max_node_size = 0.05
	node_sizes = []
	#edgesizes
	edge_size = .02
	#partitions
	partitions_with_colors = {}
	node_partition_coloring = false
	partitions_edge_color = Color(0,0,0,1)
	partitions_color_init = true
	#vertex sets
	vertex_sets_with_colors = {}
	node_vertex_sets_coloring = false
	vertex_sets_edge_color = Color(0,0,0,1)
	vertex_sets_color_init = true
	#misc
	graph_moving = false
	current_zoom_level = 1.0
	#loaded
	partition_loaded = false
	vertexset_loaded = false
	
	
