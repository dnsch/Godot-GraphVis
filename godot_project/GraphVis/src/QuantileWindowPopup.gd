extends WindowDialog

onready var below_node = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Del0"


onready var quantile_grid_container = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer"

onready var added_quantile_buttons = []
onready var added_new_line_edits_old_values = []
onready var added_button_index = 0

onready var line_edit_array = []
onready var line_edit_applied_array = []

#left side quantile buttons
onready var color_picker_left_0 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer/ColorPickerButton0"
onready var color_picker_left_1 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer/ColorPickerButton1"


#right side quantile buttons
onready var below_node_right = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Del0"
onready var quantile_grid_container_right = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer"
onready var right_side_label_to = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/LabelTo"
onready var right_side_one_panel = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Panel1"
onready var right_side_one_panel_copy = right_side_one_panel.duplicate()
onready var right_side_one_panel_label1 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Panel1/Label1"
onready var right_side_one_panel2 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Panel2"
onready var right_side_one_line_edit1 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Panel2/LineEdit1"
onready var color_picker_right_0 = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/ColorPickerButton0Right"


onready var added_quantile_buttons_right = []
onready var added_new_line_edits_old_values_right = []
onready var added_button_index_right = 0

onready var line_edit_array_right = []
onready var line_edit_applied_array_right = []


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("gradient_list_changed", self, "_on_gradient_list_changed")
	GlobalSettings.connect("quantiles_list_changed", self, "_on_quantiles_list_changed")
	GlobalSettings.connect("option_changes_reset", self, "_on_option_changes_reset")
	
	#init gradient preconf:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = Color("#ffffff")
	GlobalVariables.edge_gradients_with_colors[float(1)] = Color("#000000")
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = Color("#ffffff")
	GlobalVariables.edge_quantiles_with_colors[float(1)] = Color("#000000")
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	
	get_close_button().visible = false

func _on_option_changes_reset():
	added_quantile_buttons = []
	added_new_line_edits_old_values = []
	added_button_index = 0
	line_edit_array = []
	line_edit_applied_array = []
	added_quantile_buttons_right = []
	added_new_line_edits_old_values_right = []
	added_button_index_right = 0
	line_edit_array_right = []
	line_edit_applied_array_right = []

func _on_quantiles_list_changed():
	GlobalSettings.init_quantiles_list()
	GlobalVariables.quantiles_initialized = true

func _on_gradient_list_changed(value):
	
	below_node = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Del0"
	for added_button in added_quantile_buttons:
		added_button.queue_free()
	added_quantile_buttons = []
	added_button_index = 0
#
	color_picker_left_0.color = GlobalVariables.edge_gradients_with_colors[float(0)]
	color_picker_left_1.color = GlobalVariables.edge_gradients_with_colors[float(1)]
	
	color_picker_right_0.color = GlobalVariables.edge_gradients_with_colors[float(0)]
	
	for quantile in GlobalVariables.edge_gradients_quantiles_list.slice(1,GlobalVariables.edge_gradients_quantiles_list.size()-2):
		var new_panel = Panel.new()
		
		quantile_grid_container.add_child_below_node(below_node, new_panel)
		added_quantile_buttons.push_back(new_panel)
		var new_line_edit = LineEdit.new()
		new_line_edit.text = str(quantile)
		new_panel.add_child(new_line_edit)
		new_line_edit.set_align(1)
		new_line_edit.set_anchors_preset(15)
		new_line_edit.set("custom_styles/normal",StyleBoxEmpty.new())
		added_quantile_buttons.push_back(new_line_edit)
		added_new_line_edits_old_values.push_back(0)
		below_node = new_panel
		var new_color_picker = ColorPickerButton.new()
		new_color_picker.color = GlobalVariables.edge_gradients_with_colors[float(quantile)]
		new_color_picker.set_default_cursor_shape(2)
		quantile_grid_container.add_child_below_node(below_node, new_color_picker)
		added_quantile_buttons.push_back(new_color_picker)
		below_node = new_color_picker
		var new_delete_button = Button.new()
		new_delete_button.text = "Del"
		new_delete_button.set_default_cursor_shape(2)
		quantile_grid_container.add_child_below_node(below_node, new_delete_button)
		added_quantile_buttons.push_back(new_delete_button)
		below_node = new_delete_button
		
		new_line_edit.connect("gui_input", self, "_on_gui_input", [new_line_edit, added_new_line_edits_old_values, new_color_picker, added_button_index])
		new_color_picker.connect("color_changed", self, "_on_color_changed",[new_color_picker, new_line_edit])
		new_delete_button.connect("pressed", self, "_on_del_button_pressed",[new_panel,new_line_edit, new_color_picker, new_delete_button,added_quantile_buttons,added_button_index])
		line_edit_applied_array.push_back(0)
		added_button_index += 1
	
	#quantile right buttons:
	below_node_right = $"MarginContainer/VBoxContainer/GridContainer/MarginContainer3/PanelContainer/MarginContainer/ScrollContainer/GridContainer/Del0"
	for added_button_right in added_quantile_buttons_right:
		added_button_right.queue_free()
	added_quantile_buttons_right = []
	added_button_index_right = 0
	

	if (GlobalVariables.edge_gradients_quantiles_list.size() == 2):
		right_side_one_panel2.visible = false
		right_side_one_line_edit1.visible = false
		right_side_one_panel.visible = true
		right_side_one_panel_label1.visible = true
	else:
		var quantile_idx = 1
		for quantile in GlobalVariables.edge_gradients_quantiles_list.slice(1,GlobalVariables.edge_gradients_quantiles_list.size()-2):
			var new_panel_right = Panel.new()
			quantile_grid_container_right.add_child_below_node(below_node_right, new_panel_right)
			added_quantile_buttons_right.push_back(new_panel_right)
			var new_line_edit_right = LineEdit.new()
			new_line_edit_right.text = str(quantile)
			new_panel_right.add_child(new_line_edit_right)
			new_line_edit_right.set_align(1)
			new_line_edit_right.set_anchors_preset(15)
			new_line_edit_right.set("custom_styles/normal",StyleBoxEmpty.new())
			added_quantile_buttons_right.push_back(new_line_edit_right)
			added_new_line_edits_old_values_right.push_back(0)
			below_node_right = new_panel_right
			
			var new_label_right = Label.new()
			new_label_right.text = "to"
			quantile_grid_container_right.add_child_below_node(below_node_right, new_label_right)
			new_label_right.set_align(1)
			new_label_right.set_valign(1)
			new_label_right.set_anchors_preset(8)
			new_label_right.set_anchors_preset(15)
			added_quantile_buttons_right.push_back(new_label_right)
			below_node_right = new_label_right
			
			if (quantile == GlobalVariables.edge_gradients_quantiles_list[-2]):
				var new_panel_right2 = Panel.new()
				quantile_grid_container_right.add_child_below_node(below_node_right, new_panel_right2)
				added_quantile_buttons_right.push_back(new_panel_right2)
				var new_label_right2 = Label.new()
				new_label_right2.text = str(1)
				new_panel_right2.add_child(new_label_right2)
				new_label_right2.set_align(1)
				new_label_right2.set_valign(1)
				new_label_right2.set_anchors_preset(15)
				added_quantile_buttons_right.push_back(new_label_right2)
				below_node_right = new_panel_right2
				
				var new_color_picker_right = ColorPickerButton.new()
				new_color_picker_right.color = GlobalVariables.edge_quantiles_with_colors[float(quantile)]
				new_color_picker_right.set_default_cursor_shape(2)
				quantile_grid_container_right.add_child_below_node(below_node_right, new_color_picker_right)
				added_quantile_buttons_right.push_back(new_color_picker_right)
				below_node_right = new_color_picker_right
				var new_delete_button_right = Button.new()
				new_delete_button_right.text = "Del"
				new_delete_button_right.set_default_cursor_shape(2)
				quantile_grid_container_right.add_child_below_node(below_node_right, new_delete_button_right)
				added_quantile_buttons_right.push_back(new_delete_button_right)
				below_node_right = new_delete_button_right
				
				new_line_edit_right.connect("gui_input", self, "_on_gui_input_right_side", [new_line_edit_right, added_new_line_edits_old_values_right, new_color_picker_right, added_button_index_right])
				new_color_picker_right.connect("color_changed", self, "_on_color_changed_right_side",[new_color_picker_right, new_line_edit_right])
				new_delete_button_right.connect("pressed", self, "_on_del_button_pressed",[new_panel_right,new_line_edit_right, new_color_picker_right, new_delete_button_right,added_quantile_buttons_right,added_button_index_right])
				line_edit_applied_array_right.push_back(0)
				added_button_index_right += 1
			
			else:
				var new_panel_right2 = Panel.new()
				quantile_grid_container_right.add_child_below_node(below_node_right, new_panel_right2)
				added_quantile_buttons_right.push_back(new_panel_right2)
				var new_line_edit_right2 = LineEdit.new()
				new_line_edit_right2.text = str(GlobalVariables.edge_gradients_quantiles_list[quantile_idx+1])
				new_panel_right2.add_child(new_line_edit_right2)
				new_line_edit_right2.set_align(1)
				new_line_edit_right2.set_anchors_preset(15)
				new_line_edit_right2.set("custom_styles/normal",StyleBoxEmpty.new())
				added_quantile_buttons_right.push_back(new_line_edit_right2)
				added_new_line_edits_old_values_right.push_back(0)
				below_node_right = new_panel_right2
				
				var new_color_picker_right = ColorPickerButton.new()
				new_color_picker_right.color = GlobalVariables.edge_quantiles_with_colors[float(quantile)]
				new_color_picker_right.set_default_cursor_shape(2)
				quantile_grid_container_right.add_child_below_node(below_node_right, new_color_picker_right)
				added_quantile_buttons_right.push_back(new_color_picker_right)
				below_node_right = new_color_picker_right
				var new_delete_button_right = Button.new()
				new_delete_button_right.text = "Del"
				new_delete_button_right.set_default_cursor_shape(2)
				quantile_grid_container_right.add_child_below_node(below_node_right, new_delete_button_right)
				added_quantile_buttons_right.push_back(new_delete_button_right)
				below_node_right = new_delete_button_right
				
				new_line_edit_right.connect("gui_input", self, "_on_gui_input_right_side", [new_line_edit_right, added_new_line_edits_old_values_right, new_color_picker_right, added_button_index_right])
				new_color_picker_right.connect("color_changed", self, "_on_color_changed_right_side",[new_color_picker_right, new_line_edit_right])
				new_delete_button_right.connect("pressed", self, "_on_del_button_pressed",[new_panel_right,new_line_edit_right, new_color_picker_right, new_delete_button_right,added_quantile_buttons_right,added_button_index_right])
				line_edit_applied_array_right.push_back(0)
				added_button_index_right += 1
			quantile_idx += 1
		right_side_one_panel.visible = false
		right_side_one_panel_label1.visible = false
		right_side_one_panel2.visible = true
		right_side_one_line_edit1.visible = true
		right_side_one_line_edit1.text = str(GlobalVariables.edge_gradients_quantiles_list[1])

func _on_color_changed(color, new_color_picker_button, new_line_edit_button):
	GlobalVariables.edge_gradients_with_colors[float(new_line_edit_button.text)] = color
	GlobalVariables.quantiles_initialized = false

func _on_gui_input(event, new_line_edit_button, new_line_edit_current_text, new_color_picker_button, added_button_index):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		new_line_edit_current_text[added_button_index] = float(new_line_edit_button.text)
		var old_text = new_line_edit_current_text[added_button_index]
		line_edit_array.push_back([new_line_edit_button, new_line_edit_current_text, new_color_picker_button, added_button_index])

func _on_color_changed_right_side(color, new_color_picker_button, new_line_edit_button):
	GlobalVariables.edge_quantiles_with_colors[float(new_line_edit_button.text)] = color

func _on_gui_input_right_side(event, new_line_edit_button, new_line_edit_current_text, new_color_picker_button, added_button_index):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		new_line_edit_current_text[added_button_index] = float(new_line_edit_button.text)
		var old_text = new_line_edit_current_text[added_button_index]
		line_edit_array.push_back([new_line_edit_button, new_line_edit_current_text, new_color_picker_button, added_button_index])

func _on_del_button_pressed(new_panel,new_line_edit, new_color_picker,
							new_delete_button,added_quantile_buttons,added_button_index):
	
	var quantile = float(new_line_edit.text)
	GlobalVariables.edge_gradients_with_colors.erase(float(quantile))
	GlobalVariables.edge_gradients_quantiles_list.erase(float(quantile))
	
	for added_button in added_quantile_buttons.slice(added_button_index,added_button_index+4):
		added_button.queue_free()
	added_quantile_buttons.remove(added_button_index)
	added_quantile_buttons.remove(added_button_index)
	added_quantile_buttons.remove(added_button_index)
	added_quantile_buttons.remove(added_button_index)
	added_button_index-4
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	
func _on_AddQuantileButton_pressed():
	$AddQuantileWindowPopup.visible = true


func _on_ApplyButton_pressed():
	if (GlobalVariables.quantiles_initialized == false):
		GlobalSettings.init_quantiles_list()
		GlobalVariables.quantiles_initialized == true
	GlobalVariables.probs = GlobalVariables.edge_gradients_quantiles_list
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	#apply settings from changed line_edits:
	for changed_line_edit in line_edit_array:
		var new_line_edit_button = changed_line_edit[0]
		var old_text = changed_line_edit[1]
		var old_added_button_index = changed_line_edit[3]
		if (GlobalVariables.edge_gradients_with_colors.has(float(new_line_edit_button.text))):
			new_line_edit_button.text = str(old_text[old_added_button_index])
			pass
		else:
			GlobalVariables.edge_quantiles_with_colors[float(new_line_edit_button.text)] = GlobalVariables.edge_gradients_with_colors[float(old_text[old_added_button_index])]
			GlobalVariables.edge_quantiles_with_colors.erase(float(old_text[old_added_button_index]))
			GlobalVariables.edge_gradients_with_colors[float(new_line_edit_button.text)] = GlobalVariables.edge_gradients_with_colors[float(old_text[old_added_button_index])]
			GlobalVariables.edge_gradients_with_colors.erase(float(old_text[old_added_button_index]))
			GlobalVariables.probs.erase(float(old_text[old_added_button_index]))
			GlobalVariables.probs.push_back(float(new_line_edit_button.text))
			GlobalVariables.edge_gradients_quantiles_list.sort()
			GlobalVariables.probs.sort()
			GlobalSettings.change_quantiles_list()
			GlobalSettings.change_gradient_list(0)
	line_edit_array = []
	visible = false
	pass

func _on_ColorPickerButton0_color_changed(color: Color) -> void:
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color
	GlobalVariables.edge_gradients_with_colors[float(0)] = color

func _on_ColorPickerButton1_color_changed(color: Color) -> void:
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color

func _on_PlainColoringCheckButton_toggled(button_pressed: bool) -> void:
	GlobalVariables.plain_coloring = button_pressed

func _on_ColorPickerButton0Right_color_changed(color: Color) -> void:
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color
	GlobalVariables.edge_gradients_with_colors[float(0)] = color

func _on_GradientPreconfButton_pressed() -> void:
	$GradientPreconfPopup.visible = true

func _on_PlainPreconfButton_pressed() -> void:
	$PlainPreconfPopup.visible = true

func _on_DiscardButton_pressed() -> void:
	GlobalSettings.discard_gradient_colors_change()

func _on_InvertColorsButton_toggled(button_pressed: bool) -> void:
	
	var count = 0
	var start = 0
	var end = GlobalVariables.edge_gradients_quantiles_list.size()-1
	
	while (start < end):
		var temp = GlobalVariables.edge_gradients_with_colors[GlobalVariables.edge_gradients_quantiles_list[start]]
		GlobalVariables.edge_gradients_with_colors[GlobalVariables.edge_gradients_quantiles_list[start]] = GlobalVariables.edge_gradients_with_colors[GlobalVariables.edge_gradients_quantiles_list[end]]
		GlobalVariables.edge_gradients_with_colors[GlobalVariables.edge_gradients_quantiles_list[end]] = temp
		
		var temp2 = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.edge_gradients_quantiles_list[start]]
		GlobalVariables.edge_quantiles_with_colors[GlobalVariables.edge_gradients_quantiles_list[start]] = GlobalVariables.edge_quantiles_with_colors[GlobalVariables.edge_gradients_quantiles_list[end]]
		GlobalVariables.edge_quantiles_with_colors[GlobalVariables.edge_gradients_quantiles_list[end]] = temp2
		
		start += 1
		end -= 1
	GlobalSettings.change_gradient_list(0)
