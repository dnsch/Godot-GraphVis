extends WindowDialog


onready var grid_container = $"MarginContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer"
onready var partitions_edge_color_picker = $"MarginContainer/VBoxContainer/PanelContainer2/HBoxContainer/ColorPickerButton"

onready var below_node

onready var added_partition_buttons = []
onready var added_button_index = 0
onready var current_config = {}
onready var current_partitions_edge_color

onready var color_picker_button_arr = []
onready var checkbox_button_arr = []

onready var alpha_value_popup = $"AlphaValuePopup"
onready var alpha_slider_label = $"AlphaValuePopup/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/AlphaSliderLabel"

func _ready() -> void:
	GlobalSettings.connect("partitionid_list_changed", self, "_on_partitionid_list_changed")

func _on_partitionid_list_changed():
	for added_button in added_partition_buttons:
		added_button.queue_free()
	added_partition_buttons = []
	added_button_index = 0
	color_picker_button_arr = []
	checkbox_button_arr = []
	if (GlobalVariables.partitions_color_init):
		for partition_id in GlobalVariables.gvis_obj.graph_get_partition_count():
			var new_panel = Panel.new()
			grid_container.add_child(new_panel)
			added_partition_buttons.push_back(new_panel)
			new_panel.set_h_size_flags(3)
			new_panel.set_anchors_preset(15)
			new_panel.set_v_grow_direction(2)
			var new_label = Label.new()
			new_label.text = str(partition_id)
			new_panel.add_child(new_label)
			new_label.set_align(1)
			new_label.set_anchors_preset(8)
			new_label.set_v_grow_direction(2)
			new_label.set("custom_styles/normal",StyleBoxEmpty.new())
			added_partition_buttons.push_back(new_label)
			below_node = new_panel
			var new_color_picker = ColorPickerButton.new()
			new_color_picker.color = Color(1,1,1,1)
			new_color_picker.set_default_cursor_shape(2)
			new_color_picker.set_anchors_preset(15)
			new_color_picker.set_h_size_flags(3)
			grid_container.add_child_below_node(below_node, new_color_picker)
			added_partition_buttons.push_back(new_color_picker)
			below_node = new_color_picker
			var new_visible_check_box = CheckBox.new()
			new_visible_check_box.pressed = true
			grid_container.add_child_below_node(below_node, new_visible_check_box)
			added_partition_buttons.push_back(new_visible_check_box)
			below_node = new_visible_check_box
			
			new_color_picker.connect("color_changed", self, "_on_color_changed",[new_color_picker, new_label])
			new_visible_check_box.connect("toggled", self, "_on_visible_checkbox_toggled",[new_color_picker, new_label])

			added_button_index += 1
			GlobalVariables.partitions_with_colors[partition_id] = Color(1,1,1,1)
			color_picker_button_arr.append(new_color_picker)
			checkbox_button_arr.append(new_visible_check_box)
			current_config[partition_id]= GlobalVariables.partitions_with_colors[partition_id]
		current_partitions_edge_color = Color(0,0,0,1)
		GlobalVariables.partitions_color_init = false
	else:
		for partition_id in GlobalVariables.gvis_obj.graph_get_partition_count():
			var new_panel = Panel.new()
			grid_container.add_child(new_panel)
			added_partition_buttons.push_back(new_panel)
			new_panel.set_h_size_flags(3)
			new_panel.set_anchors_preset(15)
			new_panel.set_v_grow_direction(2)
			var new_label = Label.new()
			new_label.text = str(partition_id)
			new_panel.add_child(new_label)
			new_label.set_align(1)
			new_label.set_anchors_preset(8)
			new_label.set_v_grow_direction(2)
			new_label.set("custom_styles/normal",StyleBoxEmpty.new())
			added_partition_buttons.push_back(new_label)
			below_node = new_panel
			var new_color_picker = ColorPickerButton.new()
			new_color_picker.color = GlobalVariables.partitions_with_colors[partition_id]
			new_color_picker.set_default_cursor_shape(2)
			new_color_picker.set_anchors_preset(15)
			new_color_picker.set_h_size_flags(3)
			grid_container.add_child_below_node(below_node, new_color_picker)
			added_partition_buttons.push_back(new_color_picker)
			below_node = new_color_picker
			var new_visible_check_box = CheckBox.new()
			new_visible_check_box.pressed = true
			grid_container.add_child_below_node(below_node, new_visible_check_box)
			added_partition_buttons.push_back(new_visible_check_box)
			below_node = new_visible_check_box
			
			new_color_picker.connect("color_changed", self, "_on_color_changed",[new_color_picker, new_label])
			new_visible_check_box.connect("toggled", self, "_on_visible_checkbox_toggled",[new_color_picker, new_label])
			
			added_button_index += 1
			color_picker_button_arr.append(new_color_picker)
			checkbox_button_arr.append(new_visible_check_box)
			current_config[partition_id]= GlobalVariables.partitions_with_colors[partition_id]
		current_partitions_edge_color = GlobalVariables.partitions_edge_color



func _on_color_changed(color, new_color_picker_button, new_label_button):
	current_config[int(float(new_label_button.text))] = color
	new_color_picker_button.color = color

func _on_visible_checkbox_toggled(button_pressed,new_color_picker_button, new_label_button):
	if button_pressed:
		new_color_picker_button.color.a = 1
		current_config[int(float(new_label_button.text))] = new_color_picker_button.color
	else:
		new_color_picker_button.color.a = 0
		current_config[int(float(new_label_button.text))] = new_color_picker_button.color

func _on_RandomButton_pressed() -> void:
	var part_id = 0
	GlobalVariables.random_generator.randomize()
	var random_color
	for color_picker_button in color_picker_button_arr:
		random_color = Color(GlobalVariables.random_generator.randf(),GlobalVariables.random_generator.randf(),
							GlobalVariables.random_generator.randf(),1)
		color_picker_button.color = random_color
		current_config[part_id] = random_color
		part_id += 1

func _on_ApplyButton_pressed() -> void:
	for partition_id in GlobalVariables.gvis_obj.graph_get_partition_count():
		GlobalVariables.partitions_with_colors[partition_id] = current_config[partition_id]
	partitions_edge_color_picker.color = current_partitions_edge_color
	GlobalVariables.partitions_edge_color = current_partitions_edge_color
	GlobalSettings.change_partitionid_list()
	visible = false

func _on_DontApplyButton_pressed() -> void:
	var part_id = 0
	for color_picker_button in color_picker_button_arr:
		color_picker_button.color = GlobalVariables.partitions_with_colors[int(part_id)]
		part_id += 1
	partitions_edge_color_picker = GlobalVariables.partitions_edge_color
	visible = false

func _on_ColorPickerButton_color_changed(color: Color) -> void:
	current_partitions_edge_color = color

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var part_id = 0
		for color_picker_button in color_picker_button_arr:
			color_picker_button.color.a = 0
			current_config[part_id] = color_picker_button.color.a
			checkbox_button_arr[part_id].pressed = true
			part_id += 1
	else:
		var part_id = 0
		for color_picker_button in color_picker_button_arr:
			color_picker_button.color.a = 1
			current_config[part_id] = color_picker_button.color.a
			checkbox_button_arr[part_id].pressed = false
			part_id += 1

func _on_HSlider_value_changed(value: float) -> void:
	alpha_slider_label.text = str(value)

func _on_AlphaButton_pressed() -> void:
	alpha_value_popup.visible = true

func _on_Button_pressed() -> void:
	var part_id = 0
	GlobalVariables.random_generator.randomize()
	var random_color
	for color_picker_button in color_picker_button_arr:
		color_picker_button.color.a = float(alpha_slider_label.text)
		current_config[part_id] = color_picker_button.color
		part_id += 1
	alpha_value_popup.visible = false

func _on_Button2_pressed() -> void:
	var part_id = 0
	for color_picker_button in color_picker_button_arr:
		color_picker_button.color = GlobalVariables.partitions_with_colors[int(part_id)]
		part_id += 1
	partitions_edge_color_picker = GlobalVariables.partitions_edge_color
	alpha_value_popup.visible = false
