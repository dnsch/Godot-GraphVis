extends Node

#basic
signal background_color_changed(value)
#nodes
signal node_visibility_toggled(value)
signal node_color_changed(value)
signal node_alpha_changed(value)
signal node_size_changed(value)
signal degree_size_list_changed()
signal degree_size_list_change_applied()

#edges
signal edge_visibility_toggled(value)
signal arrow_visibility_toggled(value)
signal edge_color_changed(value)
signal edge_alpha_changed(value)
signal edge_size_changed(value)
signal edge_triangle_strip_changed(value)

#edge gradients
signal quantiles_list_initialized()
signal quantiles_list_changed()
signal gradient_list_changed(value)
signal gradient_colors_change_applied()
signal gradient_colors_change_discarded()

#partitions
signal partitionid_list_changed()
signal node_partition_colors_change_applied()
signal edge_partition_colors_change_applied()

#vertex_set
signal vertexsetid_list_changed()
signal node_vertex_set_colors_change_applied()
signal edge_vertex_set_colors_change_applied()

#misc
signal option_changes_reset()
signal partition_loaded()
signal vertexset_loaded()

#basic
func toggle_fullscreen(value):
	OS.window_fullscreen = value

#nodes
func change_background_color(value):
	emit_signal("background_color_changed", value)

func toggle_node_visibility(value):
	emit_signal("node_visibility_toggled", value)

func change_node_color(value):
	emit_signal("node_color_changed", value)

func change_node_alpha(value):
	emit_signal("node_alpha_changed", value)

func change_node_size(value):
	emit_signal("node_size_changed", value)

func change_degree_size_list():
	emit_signal("degree_size_list_changed")

func apply_degree_size_list_change():
	emit_signal("degree_size_list_change_applied")

#edges
func toggle_edge_visibility(value):
	emit_signal("edge_visibility_toggled", value)

func toggle_arrow_visibility(value):
	emit_signal("arrow_visibility_toggled", value)

func change_edge_color(value):
	emit_signal("edge_color_changed", value)

func change_edge_alpha(value):
	emit_signal("edge_alpha_changed", value)

func change_edge_size(value):
	emit_signal("edge_size_changed", value)

func change_edge_triangle_strip(value):
	emit_signal("edge_triangle_strip_changed", value)

#edge gradients
func init_quantiles_list():
	emit_signal("quantiles_list_initialized")

func change_quantiles_list():
	emit_signal("quantiles_list_changed")

func change_gradient_list(value):
	emit_signal("gradient_list_changed", value)

func apply_gradient_colors_change():
	emit_signal("gradient_colors_change_applied")

func discard_gradient_colors_change():
	emit_signal("gradient_colors_change_discarded")

#partitions
func change_partitionid_list():
	emit_signal("partitionid_list_changed")

func apply_node_partition_colors_change():
	emit_signal("node_partition_colors_change_applied")

func apply_edge_partition_colors_change():
	emit_signal("edge_partition_colors_change_applied")

#vertex_set
func change_vertexsetid_list():
	emit_signal("vertexsetid_list_changed")

func apply_node_vertex_set_colors_change():
	emit_signal("node_vertex_set_colors_change_applied")

func apply_edge_vertex_set_colors_change():
	emit_signal("edge_vertex_set_colors_change_applied")

#misc
func reset_option_changes():
	emit_signal("option_changes_reset")
	
func load_partition():
	emit_signal("partition_loaded")
	
func load_vertexset():
	emit_signal("vertexset_loaded")

