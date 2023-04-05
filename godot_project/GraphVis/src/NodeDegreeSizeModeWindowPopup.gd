extends WindowDialog


onready var grid_container = $"MarginContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer"
onready var spin_box = $"MarginContainer/VBoxContainer/MarginContainer4/HBoxContainer/SpinBox"
onready var below_node

onready var added_partition_buttons = []
onready var added_button_index = 0
onready var current_config = {}

onready var hslider_button_arr = []
onready var new_label2_button_arr = []
onready var checkbox_button_arr = []

func _ready() -> void:
	GlobalSettings.connect("degree_size_list_changed", self, "_on_degree_size_list_changed")
	get_close_button().visible = false

func _on_degree_size_list_changed():
	for added_button in added_partition_buttons:
		added_button.queue_free()
	added_partition_buttons = []
	added_button_index = 0
	hslider_button_arr = []
	checkbox_button_arr = []
	new_label2_button_arr = []
	if (GlobalVariables.degrees_sizes_init):
		for node_degree in GlobalVariables.gvis_obj.graph_getMaxDegree()+1:
			var new_panel = Panel.new()
			grid_container.add_child(new_panel)
			added_partition_buttons.push_back(new_panel)
			new_panel.set_h_size_flags(3)
			new_panel.set_anchors_preset(15)
			new_panel.set_v_grow_direction(2)
			var new_label = Label.new()
			new_label.text = str(node_degree)
			new_panel.add_child(new_label)
			new_label.set_align(1)
			new_label.set_anchors_preset(8)
			new_label.set_v_grow_direction(2)
			new_label.set("custom_styles/normal",StyleBoxEmpty.new())
			added_partition_buttons.push_back(new_label)
			below_node = new_panel
			var new_label2 = Label.new()
			new_label2.text = str(1)
			grid_container.add_child_below_node(below_node, new_label2)
			new_label2.set_align(1)
			new_label2.set_anchors_preset(8)
			new_label2.set_v_grow_direction(2)
			new_label2.set("custom_styles/normal",StyleBoxEmpty.new())
			added_partition_buttons.push_back(new_label2)
			new_label2_button_arr.append(new_label2)
			below_node = new_label2
			var new_hslider = HSlider.new()
			new_hslider.set_default_cursor_shape(2)
			new_hslider.set_anchors_preset(15)
			new_hslider.set_h_size_flags(3)
			new_hslider.max_value = 0.05
			new_hslider.min_value = 0.01
			new_hslider.step = 0.001
			new_hslider.value = 0.01
			grid_container.add_child_below_node(below_node, new_hslider)
			added_partition_buttons.push_back(new_hslider)
			hslider_button_arr.push_back(new_hslider)
			below_node = new_hslider
			var new_visible_check_box = CheckBox.new()
			new_visible_check_box.pressed = true
			grid_container.add_child_below_node(below_node, new_visible_check_box)
			added_partition_buttons.push_back(new_visible_check_box)
			below_node = new_visible_check_box
			
			
			new_hslider.connect("value_changed", self, "_on_value_changed",[new_label, new_label2])
			new_visible_check_box.connect("toggled", self, "_on_visible_checkbox_toggled",[new_label])

			added_button_index += 1
			GlobalVariables.degrees_with_sizes[node_degree] = .01
			checkbox_button_arr.append(new_visible_check_box)
			current_config[node_degree]= GlobalVariables.degrees_with_sizes[node_degree]
		GlobalVariables.degrees_sizes_init = false
	else:
		for node_degree in GlobalVariables.gvis_obj.graph_getMaxDegree()+1:
			var new_panel = Panel.new()
			grid_container.add_child(new_panel)
			added_partition_buttons.push_back(new_panel)
			new_panel.set_h_size_flags(3)
			new_panel.set_anchors_preset(15)
			new_panel.set_v_grow_direction(2)
			var new_label = Label.new()
			new_label.text = str(node_degree)
			new_panel.add_child(new_label)
			new_label.set_align(1)
			new_label.set_anchors_preset(8)
			new_label.set_v_grow_direction(2)
			new_label.set("custom_styles/normal",StyleBoxEmpty.new())
			added_partition_buttons.push_back(new_label)
			below_node = new_panel
			var new_label2 = Label.new()
			new_label2.text = str(GlobalVariables.degrees_with_sizes[node_degree]*100)
			grid_container.add_child_below_node(below_node, new_label2)
			new_label2.set_align(1)
			new_label2.set_anchors_preset(8)
			new_label2.set_v_grow_direction(2)
			new_label2.set("custom_styles/normal",StyleBoxEmpty.new())
			new_label2_button_arr.push_back(new_label2)
			added_partition_buttons.push_back(new_label2)
			below_node = new_label2
			var new_hslider = HSlider.new()
			new_hslider.set_default_cursor_shape(2)
			new_hslider.set_anchors_preset(15)
			new_hslider.set_h_size_flags(3)
			new_hslider.max_value = 0.05
			new_hslider.min_value = 0.01
			new_hslider.step = 0.001
			new_hslider.value = GlobalVariables.degrees_with_sizes[node_degree]
			grid_container.add_child_below_node(below_node, new_hslider)
			added_partition_buttons.push_back(new_hslider)
			hslider_button_arr.append(new_hslider)
			below_node = new_hslider
			var new_visible_check_box = CheckBox.new()
			new_visible_check_box.pressed = true
			grid_container.add_child_below_node(below_node, new_visible_check_box)
			added_partition_buttons.push_back(new_visible_check_box)
			below_node = new_visible_check_box
			
			
			new_hslider.connect("value_changed", self, "_on_value_changed",[new_label, new_label2])
			new_visible_check_box.connect("toggled", self, "_on_visible_checkbox_toggled",[new_label])

			added_button_index += 1
			checkbox_button_arr.append(new_visible_check_box)
			current_config[node_degree] = GlobalVariables.degrees_with_sizes[node_degree]
			
func _on_value_changed(value, new_label_button, new_label2_button):
	current_config[int(float(new_label_button.text))] = value
	new_label2_button.text = str(value*100)
	
func _on_ApplyButton_pressed() -> void:
	for node_degree in GlobalVariables.gvis_obj.graph_getMaxDegree()+1:
		GlobalVariables.degrees_with_sizes[node_degree] = current_config[node_degree]
	GlobalSettings.change_degree_size_list()
	GlobalVariables.option_node.set_exclusive(false)
	visible = false

func _on_DontApplyButton_pressed() -> void:
	var node_id = 0
	for hslider_button in hslider_button_arr:
		hslider_button.value = GlobalVariables.degrees_with_sizes[int(node_id)]
		node_id += 1
	visible = false

func _on_LinearSizingButton_pressed() -> void:
	var current_size = 0.01
	var increment = (GlobalVariables.max_node_size)/(GlobalVariables.gvis_obj.graph_getMaxDegree()+2)
	for node_degree in GlobalVariables.gvis_obj.graph_getMaxDegree()+1:
		current_config[node_degree] = current_size
		new_label2_button_arr[node_degree].text = str(current_size*100)
		hslider_button_arr[node_degree].value = current_size
		current_size += increment
	pass

func _on_SpinBox_value_changed(value: float) -> void:
	GlobalVariables.max_node_size = float(value/100)
	for node_degree in GlobalVariables.gvis_obj.graph_getMaxDegree()+1:
		hslider_button_arr[node_degree].max_value = float(value/100)
