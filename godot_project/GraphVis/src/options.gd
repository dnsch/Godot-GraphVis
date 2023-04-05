extends Popup

#node settings
onready var nodes_settings_changes = []
onready var nodes_settings_changes_dict = {}

#edge settings
onready var edges_settings_changes = []
onready var edges_settings_changes_dict = {}

# base options
onready var display_mode_option_button = $"OptionTabs/Base Options/MarginContainer/GridContainer/DisplayModeOptionButton"
onready var background_color_picker = $"OptionTabs/Base Options/MarginContainer/GridContainer/BackgroundColorPickerButton"

# node options
onready var node_visibility_check_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeVisibilityCheckButton"
onready var node_color_picker = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorPickerButton"
onready var node_alpha_hslider_label = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeAlphaHBox/NodeAlphaSliderLabel"
onready var node_alpha_hslider = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeAlphaHBox/NodeAlphaHSlider"
onready var node_size_hslider_label = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeHBox/NodeSizeSliderLabel"
onready var node_size_hslider = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeHBox/NodeSizeHSlider"
onready var node_plain_color_picker = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorPickerButton"
onready var node_plain_color_picker_placeholder = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorPlaceHolder"
onready var node_coloring_plain_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorHBox/NodeColorPlain"
onready var node_coloring_partition_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorHBox/NodeColorPartitionID"
onready var node_size_button_equal = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeHBox2/NodeSizeButtonEqual"
onready var node_size_button_degree = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeHBox2/NodeSizeButtonDegree"
onready var node_size_equal_placeholder = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeEqualPlaceholder"
onready var node_size_hbox = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeSizeHBox"
onready var node_settings_apply_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/MarginContainer/NodesSettingsApplyButton"
onready var node_coloring_vertexset_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Nodes/MarginContainer/NodesSettingsVBox/NodesSettings/NodeColorHBox/NodeColorVertexSetID"
#edge options
onready var edge_coloring_plain_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/PlainButton"
onready var edge_coloring_quantile_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/QuantileButton"
onready var visibility_check_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeVisibilityCheckButton"
onready var arrow_visibility_check_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/ArrowVisibilityCheckButton"
onready var edge_color_picker = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorPickerButton"
onready var edge_alpha_hslider_label = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeAlphaHBox/EdgeAlphaSliderLabel"
onready var edge_alpha_hslider = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeAlphaHBox/EdgeAlphaHSlider"
onready var edge_width_check_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeWidthVBox/EdgeWidthCheckButton"
onready var edge_width_hslider_label = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeWidthVBox/EdgeWidthHBox/EdgeWidthSliderLabel"
onready var edge_width_hslider = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeWidthVBox/EdgeWidthHBox/EdgeWidthHSlider"
onready var edge_plain_color_picker = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorPickerButton"
onready var edge_plain_color_picker_placeholder = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorPlaceHolder"
onready var edge_plain_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/PlainButton"
onready var edge_quantile_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/QuantileButton"
onready var edge_settings_apply_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/MarginContainer/EdgesSettingsApplyButton"
onready var edge_partition_coloring_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/PartitionButton"
onready var edge_partition_vertexset_button = $"OptionTabs/Graph Appearance/MarginContainer/TabContainer/Edges/MarginContainer/EdgesSettingsVBox/EdgesSettings/EdgeColorHBox/VertexSetButton"
var ok = false

func _ready():
	GlobalSettings.connect("gradient_colors_change_discarded", self, "_on_gradient_colors_change_discarded")
	GlobalSettings.connect("option_changes_reset", self, "_on_option_changes_reset")
	GlobalSettings.connect("node_alpha_changed", self, "_on_node_alpha_changed")
	GlobalSettings.connect("edge_alpha_changed", self, "_on_edge_alpha_changed")
	GlobalSettings.connect("partition_loaded", self, "_on_partition_loaded")
	GlobalSettings.connect("vertexset_loaded", self, "_on_vertexset_loaded")
	
	GlobalVariables.option_node = self
	$"OptionTabs/Base Options/MarginContainer/GridContainer/BackgroundColorPickerButton".color = Color(0.121569, 0.14902, 0.317647)

#basic
func _on_DisplayModeOptionButton_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

func _on_BackgroundColorPickerButton_color_changed(color):
	GlobalSettings.change_background_color(color)

func _on_NodeScannerCheckButton_toggled(button_pressed: bool) -> void:
	GlobalVariables.node_scanner = button_pressed

func _on_NodeScannerColorPickerButton_color_changed(color: Color) -> void:
	GlobalVariables.node_scanner_color = color

func _on_NodeSelectionColorPickerButton_color_changed(color: Color) -> void:
	GlobalVariables.node_selection_node_color = color

func _on_NodeSelectionColorPickerButton2_color_changed(color: Color) -> void:
	GlobalVariables.node_selection_edge_color = color

#nodes
func _on_NodeVisibilityCheckButton_toggled(button_pressed):
	nodes_settings_changes.push_back(0)
	nodes_settings_changes_dict["_on_NodeVisibilityCheckButton_toggled"] = button_pressed

func _on_NodeColorPickerButton_color_changed(color):
	nodes_settings_changes.push_back(1)
	nodes_settings_changes_dict["_on_NodeColorPickerButton_color_changed"] = color

func _on_node_alpha_changed(value):
	_on_NodeAlphaHSlider_value_changed(value)
	node_alpha_hslider.value = value

func _on_NodeAlphaHSlider_value_changed(value):
	nodes_settings_changes.push_back(2)
	nodes_settings_changes_dict["_on_NodeAlphaHSlider_value_changed"] = value
	node_alpha_hslider_label.text = str(value)

func _on_NodeSizeHSlider_value_changed(value):
	nodes_settings_changes.push_back(3)
	nodes_settings_changes_dict["_on_NodeSizeHSlider_value_changed"] = value
	node_size_hslider_label.text = str(value*100)

func _on_NodeColorPlain_pressed() -> void:
	GlobalVariables.node_partition_coloring = false
	node_plain_color_picker.visible = true
	node_plain_color_picker_placeholder.visible = true
	GlobalSettings.change_node_alpha(1)
	_on_NodeColorPickerButton_color_changed(node_plain_color_picker.color)

func _on_NodeColorPartitionID_pressed() -> void:
	if (GlobalVariables.partition_loaded):
		GlobalVariables.node_partition_coloring = true
		node_plain_color_picker.visible = false
		node_plain_color_picker_placeholder.visible = false
		$PartitionColoringWindowPopup.visible=true
		nodes_settings_changes.push_back(4)

func _on_node_partition_colors_change_discarded():
	GlobalVariables.node_partition_coloring = false
	node_plain_color_picker.visible = true
	node_plain_color_picker_placeholder.visible = true
	while (nodes_settings_changes.find(4) != -1):
		nodes_settings_changes.erase(4)
	node_coloring_partition_button.pressed = false
	node_coloring_plain_button.pressed = true
	$PartitionColoringWindowPopup.visible= false
	_on_NodeColorPickerButton_color_changed(node_plain_color_picker.color)

func _on_NodeColorVertexSetID_pressed() -> void:
	if GlobalVariables.vertexset_loaded:
		GlobalVariables.node_vertex_sets_coloring = true
		node_plain_color_picker.visible = false
		node_plain_color_picker_placeholder.visible = false
		$VertexSetColoringWindowPopup.visible=true
		nodes_settings_changes.push_back(5)

func _on_node_vertex_set_colors_change_discarded():
	GlobalVariables.node_vertex_sets_coloring = false
	node_plain_color_picker.visible = true
	node_plain_color_picker_placeholder.visible = true
	while (nodes_settings_changes.find(5) != -1):
		nodes_settings_changes.erase(5)
	node_coloring_partition_button.pressed = false
	node_coloring_plain_button.pressed = true
	$VertexSetColoringEdgeWindowPopup.visible= false
	_on_NodeColorPickerButton_color_changed(node_plain_color_picker.color)

func _on_NodeSizeButtonDegree_pressed() -> void:
	GlobalVariables.degrees_node_sizing = true
	GlobalSettings.change_degree_size_list()
	node_size_hbox.visible = false
	node_size_equal_placeholder.visible = false
	$NodeDegreeSizeModeWindowPopup.visible=true
	GlobalVariables.option_node.set_exclusive(true)
	nodes_settings_changes.push_back(6)
	
func _on_NodeSizeButtonEqual_pressed() -> void:
	GlobalVariables.degrees_node_sizing = false
	node_size_hbox.visible = true
	node_size_equal_placeholder.visible = true
	while (nodes_settings_changes.find(6) != -1):
		nodes_settings_changes.erase(6)
	node_size_button_degree.pressed = false
	node_size_button_equal.pressed = true
	_on_NodeSizeHSlider_value_changed(node_size_hslider.value)

func _on_NodesSettingsApplyButton_pressed() -> void:
	var current_node = node_settings_apply_button
	current_node.set_default_cursor_shape(5)
	while (current_node.name != "OptionsMenu"):
		current_node = current_node.get_parent()
		current_node.set_default_cursor_shape(5)
	
	yield(get_tree(), "idle_frame")
	get_viewport().warp_mouse(get_viewport().get_mouse_position())
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	if (nodes_settings_changes.size() == 0):
		pass
	else:
		for settings_index in range(nodes_settings_changes.size()):
			if (nodes_settings_changes[settings_index] == 0):
				var button_pressed = nodes_settings_changes_dict["_on_NodeVisibilityCheckButton_toggled"]
				GlobalSettings.toggle_node_visibility(button_pressed)
			if (nodes_settings_changes[settings_index] == 1):
				var color = nodes_settings_changes_dict["_on_NodeColorPickerButton_color_changed"]
				GlobalSettings.change_node_color(color)
			if (nodes_settings_changes[settings_index] == 2):
				var value = nodes_settings_changes_dict["_on_NodeAlphaHSlider_value_changed"]
				GlobalSettings.change_node_alpha(value)
			if (nodes_settings_changes[settings_index] == 3):
				var value = nodes_settings_changes_dict["_on_NodeSizeHSlider_value_changed"]
				GlobalSettings.change_node_size(value)
			if (nodes_settings_changes[settings_index] == 4):
				GlobalSettings.apply_node_partition_colors_change()
			if (nodes_settings_changes[settings_index] == 5):
				GlobalSettings.apply_node_vertex_set_colors_change()
			if (nodes_settings_changes[settings_index] == 6):
				GlobalSettings.apply_degree_size_list_change()
			var settings_idx = edges_settings_changes.find(nodes_settings_changes[settings_index])
			nodes_settings_changes.remove(settings_idx)
			
	current_node = node_settings_apply_button
	current_node.set_default_cursor_shape(0)
	while (current_node.name != "OptionsMenu"):
		current_node = current_node.get_parent()
		current_node.set_default_cursor_shape(0)
	yield(get_tree(), "idle_frame")
	get_viewport().warp_mouse(get_viewport().get_mouse_position())
	
#edges
func _on_EdgeVisibilityCheckButton_toggled(button_pressed):
	edges_settings_changes.push_back(0)
	edges_settings_changes_dict["_on_EdgeVisibilityCheckButton_toggled"] = button_pressed

func _on_ArrowVisibilityCheckButton_toggled(button_pressed: bool) -> void:
	edges_settings_changes.push_back(8)
	edges_settings_changes_dict["_on_ArrowVisibilityCheckButton_toggled"] = button_pressed

func _on_EdgeColorPickerButton_color_changed(color):
	edges_settings_changes.push_back(1)
	edges_settings_changes_dict["_on_EdgeColorPickerButton_color_changed"] = color

func _on_edge_alpha_changed(value):
	_on_EdgeAlphaHSlider_value_changed(value)
	edge_alpha_hslider.value = value

func _on_EdgeAlphaHSlider_value_changed(value):
	edges_settings_changes.push_back(2)
	edges_settings_changes_dict["_on_EdgeAlphaHSlider_value_changed"] = value
	edge_alpha_hslider_label.text = str(value)


func _on_EdgeWidthHSlider_value_changed(value):
	edges_settings_changes.push_back(3)
	edges_settings_changes_dict["_on_EdgeWidthHSlider_value_changed"] = value
	edge_width_hslider_label.text = str(value)

func _on_EdgeWidthCheckButton_toggled(button_pressed):
	edges_settings_changes.push_back(4)
	edges_settings_changes_dict["_on_EdgeWidthCheckButton_toggled"] = button_pressed
	edge_width_hslider_label.visible = button_pressed
	edge_width_hslider.visible = button_pressed

func _on_EdgesSettingsApplyButton_pressed():
	var current_node = edge_settings_apply_button
	current_node.set_default_cursor_shape(5)
	while (current_node.name != "OptionsMenu"):
		current_node = current_node.get_parent()
		current_node.set_default_cursor_shape(5)
	
	yield(get_tree(), "idle_frame")
	get_viewport().warp_mouse(get_viewport().get_mouse_position())
	
	yield(get_tree().create_timer(0.2), "timeout")

	if (edges_settings_changes.size() == 0):
		pass
	else:
		for settings_index in range(edges_settings_changes.size()):
			settings_index = 0
			if (edges_settings_changes[settings_index] == 0):
				var button_pressed = edges_settings_changes_dict["_on_EdgeVisibilityCheckButton_toggled"]
				GlobalSettings.toggle_edge_visibility(button_pressed)
			if (edges_settings_changes[settings_index] == 1):
				var color = edges_settings_changes_dict["_on_EdgeColorPickerButton_color_changed"]
				GlobalSettings.change_edge_color(color)
				GlobalVariables.single_color = color
			if (edges_settings_changes[settings_index] == 2):
				var value = edges_settings_changes_dict["_on_EdgeAlphaHSlider_value_changed"]
				GlobalSettings.change_edge_alpha(value)
			if (edges_settings_changes[settings_index] == 3):
				var value = edges_settings_changes_dict["_on_EdgeWidthHSlider_value_changed"]
				GlobalSettings.change_edge_size(value)
			if (edges_settings_changes[settings_index] == 4):
				var button_pressed = edges_settings_changes_dict["_on_EdgeWidthCheckButton_toggled"]
				GlobalSettings.change_edge_triangle_strip(button_pressed)
			if (edges_settings_changes[settings_index] == 5):
				GlobalSettings.apply_gradient_colors_change()
			if (edges_settings_changes[settings_index] == 6):
				GlobalSettings.apply_edge_partition_colors_change()
			if (edges_settings_changes[settings_index] == 7):
				GlobalSettings.apply_edge_vertex_set_colors_change()
			if (edges_settings_changes[settings_index] == 8):
				var button_pressed = edges_settings_changes_dict["_on_ArrowVisibilityCheckButton_toggled"]
				GlobalSettings.toggle_arrow_visibility(button_pressed)
			var settings_idx = edges_settings_changes.find(edges_settings_changes[settings_index])
			edges_settings_changes.remove(settings_idx)
	current_node = edge_settings_apply_button
	current_node.set_default_cursor_shape(0)
	while (current_node.name != "OptionsMenu"):
		current_node = current_node.get_parent()
		current_node.set_default_cursor_shape(0)
	yield(get_tree(), "idle_frame")
	get_viewport().warp_mouse(get_viewport().get_mouse_position())

func _on_QuantileButton_pressed() -> void:
	GlobalVariables.edge_quantiles_coloring = true
	edge_plain_color_picker.visible = false
	edge_plain_color_picker_placeholder.visible = false
	$QuantileWindowPopup.visible=true
	edges_settings_changes.push_back(5)

func _on_PlainButton_pressed() -> void:
	GlobalVariables.edge_quantiles_coloring = false
	edge_plain_color_picker.visible = true
	edge_plain_color_picker_placeholder.visible = true
	_on_EdgeColorPickerButton_color_changed(edge_plain_color_picker.color)

func _on_gradient_colors_change_discarded():
	if GlobalVariables.partition_loaded:
		GlobalVariables.edge_quantiles_coloring = false
		edge_plain_color_picker.visible = true
		edge_plain_color_picker_placeholder.visible = true
		while (edges_settings_changes.find(5) != -1):
			edges_settings_changes.erase(5)
		edge_coloring_quantile_button.pressed = false
		edge_coloring_plain_button.pressed = true
		$QuantileWindowPopup.visible= false
		_on_EdgeColorPickerButton_color_changed(edge_plain_color_picker.color)

func _on_PartitionButton_pressed() -> void:
	if (GlobalVariables.partition_loaded):
		GlobalVariables.edge_quantiles_coloring = false
		edge_plain_color_picker.visible = false
		edge_plain_color_picker_placeholder.visible = false
		$PartitionColoringEdgeWindowPopup.visible = true
		edges_settings_changes.push_back(6)

func _on_partition_colors_edge_change_discarded():
	GlobalVariables.edge_quantiles_coloring = false
	edge_plain_color_picker.visible = true
	edge_plain_color_picker_placeholder.visible = true
	while (edges_settings_changes.find(6) != -1):
		edges_settings_changes.erase(6)
	edge_coloring_quantile_button.pressed = false
	edge_coloring_plain_button.pressed = true
	$PartitionColoringEdgeWindowPopup.visible= false
	_on_EdgeColorPickerButton_color_changed(edge_plain_color_picker.color)
	
func _on_VertexSetButton_pressed() -> void:
	if GlobalVariables.vertexset_loaded:
		GlobalVariables.edge_quantiles_coloring = false
		edge_plain_color_picker.visible = false
		edge_plain_color_picker_placeholder.visible = false
		$VertexSetColoringEdgeWindowPopup.visible = true
		edges_settings_changes.push_back(7)

func _on_vertex_set_colors_edge_change_discarded():
	GlobalVariables.edge_quantiles_coloring = false
	edge_plain_color_picker.visible = true
	edge_plain_color_picker_placeholder.visible = true
	while (edges_settings_changes.find(7) != -1):
		edges_settings_changes.erase(7)
	edge_coloring_quantile_button.pressed = false
	edge_coloring_plain_button.pressed = true
	$VertexSetColoringEdgeWindowPopup.visible= false
	_on_EdgeColorPickerButton_color_changed(edge_plain_color_picker.color)

#misc
func _on_option_changes_reset():
	node_visibility_check_button.pressed = true
	node_color_picker.color = Color(1,1,1,1)
	node_alpha_hslider_label.text = str(1)
	node_alpha_hslider.value = 1
	node_size_hslider_label.text = str(1)
	node_size_hslider.value = 0.01
	visibility_check_button.pressed = true
	arrow_visibility_check_button.pressed = true
	edge_color_picker.color = Color(1,1,1,1)
	edge_width_check_button.pressed = false
	edge_width_hslider_label.visible = false
	edge_width_hslider.visible = false
	edge_plain_button.pressed = true
	edge_quantile_button.pressed = false

func _on_partition_loaded():
	edge_partition_coloring_button.visible = true
	node_coloring_partition_button.visible = true
func _on_vertexset_loaded():
	node_coloring_partition_button.visible = true
	edge_partition_vertexset_button.visible = true




