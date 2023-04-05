extends Popup

#grayscale
onready var color_button_0_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer/0ColorButton"
onready var color_button_0_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer/1ColorButton"

#alpha
onready var color_button_1_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer4/0ColorButton"
onready var color_button_1_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer4/1ColorButton"

#ReGrBl
onready var color_button_2_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer2/0ColorButton"
onready var color_button_2_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer2/0ColorButton2"
onready var color_button_2_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer2/1ColorButton"

#ReOrYeGrBl
onready var color_button_3_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/0ColorButton"
onready var color_button_3_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/25ColorButton"
onready var color_button_3_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/0ColorButton2"
onready var color_button_3_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/75ColorButton"
onready var color_button_3_4 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer3/1ColorButton"

#Viridis
onready var color_button_4_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer5/0ColorButton"
onready var color_button_4_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer5/25ColorButton"
onready var color_button_4_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer5/0ColorButton2"
onready var color_button_4_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer5/75ColorButton"
onready var color_button_4_4 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer5/1ColorButton"

#Inferno
onready var color_button_5_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer6/0ColorButton"
onready var color_button_5_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer6/25ColorButton"
onready var color_button_5_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer6/0ColorButton2"
onready var color_button_5_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer6/75ColorButton"
onready var color_button_5_4 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer6/1ColorButton"

#Magma
onready var color_button_6_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer7/0ColorButton"
onready var color_button_6_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer7/25ColorButton"
onready var color_button_6_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer7/0ColorButton2"
onready var color_button_6_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer7/75ColorButton"
onready var color_button_6_4 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer7/1ColorButton"

#Plasma
onready var color_button_7_0 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer8/0ColorButton"
onready var color_button_7_1 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer8/25ColorButton"
onready var color_button_7_2 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer8/0ColorButton2"
onready var color_button_7_3 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer8/75ColorButton"
onready var color_button_7_4 = $"Background/MarginContainer/MarginContainer/GridContainer/HBoxContainer8/1ColorButton"

func _on_OKButton1_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_0_0.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_0_1.color
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_0_0.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_0_1.color
	
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
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_1_0.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_1_1.color
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_1_0.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_1_1.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
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
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_2_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_2_1.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_2_2.color
	
	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_2_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_2_1.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_2_2.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false


func _on_OKButton4_pressed() -> void:
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
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_3_4.color

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_3_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_3_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_3_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_3_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_3_4.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false


func _on_OKButtonViridis_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_4_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.25)] = color_button_4_1.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_4_2.color
	GlobalVariables.edge_gradients_with_colors[float(0.75)] = color_button_4_3.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_4_4.color

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_4_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_4_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_4_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_4_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_4_4.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false


func _on_OKButtonInferno_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_5_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.25)] = color_button_5_1.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_5_2.color
	GlobalVariables.edge_gradients_with_colors[float(0.75)] = color_button_5_3.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_5_4.color

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_5_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_5_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_5_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_5_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_5_4.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false


func _on_OKButtonMagma_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_6_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.25)] = color_button_6_1.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_6_2.color
	GlobalVariables.edge_gradients_with_colors[float(0.75)] = color_button_6_3.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_6_4.color

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_6_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_6_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_6_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_6_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_6_4.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false


func _on_OKButtonPlasma_pressed() -> void:
	GlobalVariables.edge_gradients_with_colors.clear()
	GlobalVariables.edge_quantiles_with_colors.clear()
	GlobalVariables.probs.clear()
	GlobalVariables.edge_gradients_quantiles_list.clear()
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(1))
	
	GlobalVariables.edge_gradients_with_colors[float(0)] = color_button_7_0.color
	GlobalVariables.edge_gradients_with_colors[float(0.25)] = color_button_7_1.color
	GlobalVariables.edge_gradients_with_colors[float(0.5)] = color_button_7_2.color
	GlobalVariables.edge_gradients_with_colors[float(0.75)] = color_button_7_3.color
	GlobalVariables.edge_gradients_with_colors[float(1)] = color_button_7_4.color

	GlobalVariables.edge_quantiles_with_colors[float(0)] = color_button_7_0.color
	GlobalVariables.edge_quantiles_with_colors[float(0.25)] = color_button_7_1.color
	GlobalVariables.edge_quantiles_with_colors[float(0.5)] = color_button_7_2.color
	GlobalVariables.edge_quantiles_with_colors[float(0.75)] = color_button_7_3.color
	GlobalVariables.edge_quantiles_with_colors[float(1)] = color_button_7_4.color
	
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.25))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.5))
	GlobalVariables.edge_gradients_quantiles_list.push_back(float(0.75))
	GlobalVariables.edge_gradients_quantiles_list.sort()
	GlobalVariables.probs.sort()
	
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(0)
	visible = false
