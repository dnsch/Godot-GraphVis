extends Popup

#alpha
onready var color_button_0_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer/0ColorButton"

#GrRe
onready var color_button_2_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer2/0ColorButton"
onready var color_button_2_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer2/0ColorButton2"

#GrYeOrRe
onready var color_button_3_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/0ColorButton"
onready var color_button_3_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/25ColorButton"
onready var color_button_3_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/0ColorButton2"
onready var color_button_3_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/75ColorButton"

func _on_OKButton1_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_0_0.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = Color(1,1,1,1)
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_0_0.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = Color(1,1,1,1)
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false

func _on_OKButton2_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_2_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_2_1.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = Color(1,1,1,1)
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_2_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_2_1.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = Color(1,1,1,1)
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false

func _on_OKButton3_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_3_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.25)] = color_button_3_1.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_3_2.color
	GlobalVariables.edge_gradients_with_colors[float(0.75)] = color_button_3_3.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = Color(1,1,1,1)

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_3_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_3_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_3_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_3_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = Color(1,1,1,1)
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false

