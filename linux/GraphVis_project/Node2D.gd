extends Node2D

var path 
var file_name

var gvis = GRAPHVIS.new()

var node_position
var node_positions = []
var rng = RandomNumberGenerator.new()

var window_size = OS.get_window_size()

var edge_object = preload("res://resources/Edge.tscn")

#onready var file = 'res://testgraph'


# Called when the node enters the scene tree for the first time.
func _ready():
	#GRAPHVIS.new()
	#load_file(file)
	
	
	window_size.x = 8000000
	window_size.y = 8000000
	#var f = File.new()
	#f.open(file, File.READ)
	#print(olag.get_graph_filename())
	#olag.set_graph_filename('res://simple_bowtie')
	#print(olag.get_graph_filename())
	path = OS.get_data_dir()
	#path = 'user://'
	#print(path)
	#path = 'res://testgraph'
	#file_name = 'complex_bowtie_round_ctr'
	#file_name = 'lesmis.graph'
	file_name = 'Email-EuAllMETISdir'
	#file_name = 'simple_bowtie'
	#file_name = 'netz4504_dual.wd.dg.graph'
	#var err = file.open('res://testgraph', File.READ)
	
	gvis.graph_read_file(file_name)
	print("<a")
	#gvis.draw_pos_random(window_size.x, window_size.y)
	#print(gvis.graph_get_current_coords())
	#gvis.draw_pos_random(-window_size.x/2, window_size.x/2)
	
	#var array2 = gvis.graph_get_current_coords()
	#print(array2)
	
	#_draw()
	#print(GRAPHVIS.G.number_of_edges())
	
	#print(olag.get_total())
	#print("whatta",olag.get_edge_cut())
	#olag.G
	pass # Replace with function body.
	
func draw_graph_fast():
	gvis.draw_pos_random(window_size.x, window_size.y)
	for node in range(gvis.graph_number_of_nodes()):
		#draw_circle(Vector2(gvis.graph_getX(node), gvis.graph_getY(node)),10,Color(1,0,0))
		var target
		for edge in range(gvis.graph_get_first_edge(node), gvis.graph_get_first_invalid_edge(node)):
			target = gvis.graph_getEdgeTarget(edge)
#			var instance = edge_object.instance()
#			add_child(instance)
#			instance.add_point(Vector2(gvis.graph_getX(node),gvis.graph_getY(node)))
#			instance.add_point(Vector2(gvis.graph_getX(gvis.graph_getEdgeTarget(edge)), gvis.graph_getY(gvis.graph_getEdgeTarget(edge))))
 
			 
			draw_line(Vector2(gvis.graph_getX(node),gvis.graph_getY(node)), Vector2(gvis.graph_getX(target), gvis.graph_getY(target)), Color( 0.9, 0.9, 0.9, 1 ) ,1)

func draw_graph(gvis_object):
	rng.randomize()
	var randx = rng.randi_range(0, window_size.x)
	var randy = rng.randi_range(0, window_size.y)
	for node in gvis_object.graph_number_of_nodes():
		node_position = Vector2(randx,randy)
		draw_circle(node_position,10,Color(1,0,0))
		node_positions[node] = node_position
		randx = rng.randi_range(-window_size.x/2, window_size.x/2)
		randy = rng.randi_range(-window_size.y/2, window_size.y/2)
	for node in gvis_object.graph_number_of_nodes():
		#var edge = gvis_object.graph_get_first_edge(node)
		var target
		for edge in range(gvis_object.graph_get_first_edge(node), gvis_object.graph_get_first_invalid_edge(node)):
			target = gvis_object.graph_getEdgeTarget(edge)
			draw_line(Vector2(node_positions[node][0],node_positions[node][1]), Vector2(node_positions[target][0], node_positions[target][1]), Color( 0.9, 0.9, 0.9, 1 ) ,.01)
	
func draw_current_graph(gvis_object):
	#gvis.draw_pos_random(window_size.x, window_size.y)
	for node in gvis.graph_number_of_nodes():
		draw_circle(Vector2(gvis.graph_get_current_coords()[node][0], gvis.graph_get_current_coords()[node][1]),1,Color(1,0,0))
		#var edge = gvis_object.graph_get_first_edge(node)
		for edge in range(gvis_object.graph_get_first_edge(node), gvis_object.graph_get_first_invalid_edge(node)):
			var target = gvis_object.graph_getEdgeTarget(edge)
			draw_line(Vector2(gvis.graph_get_current_coords()[node][0],gvis.graph_get_current_coords()[node][1]), Vector2(gvis.graph_get_current_coords()[target][0], gvis.graph_get_current_coords()[target][1]), Color( 0.9, 0.9, 0.9, .2 ) ,.01)
	
	
	#'define forall_edges(G,e) { for(EdgeID e = 0, end = G.number_of_edges(); e < end; ++e) {
	#define forall_nodes(G,n) { for(NodeID n = 0, end = G.number_of_nodes(); n < end; ++n) {
	#define forall_out_edges(G,e,n) { for(EdgeID e = G.get_first_edge(n), end = G.get_first_invalid_edge(n); e < end; ++e) {
	#define forall_out_edges_starting_at(G,e,n,e_bar) { for(EdgeID e = e_bar, end = G.get_first_invalid_edge(n); e < end; ++e) {
	#define forall_blocks(G,p) { for (PartitionID p = 0, end = G.get_partition_count(); p < end; p++) {
	#define endfor }}'

	#draw_circle(Vector2(rng.randi_range(0, window_size.x),rng.randi_range(0, window_size.y)),10,Color(1,0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#var k = GRAPHVIS.new()


#print(olag)
#print(GRAPHVIS.new().get_total())
#print(k.get_total())

#var s = Summator.new()
#s.add(10)
#s.add(20)
#s.add(30)
#print(s.get_total())
#s.reset()


#
#'func forall_edges(GRAPHVIS gvis, edge):
#	for edge in gvis.graph_number_of_edges():
#		'

	
	
#func draw_nodes(nodes):
#	for node in nodes:
#

func _draw():
	#draw_circle(Vector2(rng.randi_range(0, window_size.x),rng.randi_range(0, window_size.y)),10,Color(1,0,0))
	#draw_graph(gvis)
	draw_graph_fast()

#func load_file(file):
#	var f = File.new()
#	f.open(file, File.READ)
#	var index = 1
#	while not f.eof_reached(): # iterate through all lines until the end of file is reached
#		var line = f.get_line()
#		line += " "
#		print(line + str(index))
#		index += 1
#	f.close()
#	return

#func _process(delta):



func _on_Button_pressed():
	gvis.draw_pos_random(window_size.x, window_size.y)
	update()
	pass # Replace with function body.
