extends Node

var gvis = GRAPHVIS.new()

var rng = RandomNumberGenerator.new()

var window_size = OS.get_window_size()

var k_test

func _ready():
	gvis.ui_set_window_x(OS.get_window_size().x*.7)
	gvis.ui_set_window_y(OS.get_window_size().y)

func _set_graph_file(path):
	gvis.graph_read_file(path)
