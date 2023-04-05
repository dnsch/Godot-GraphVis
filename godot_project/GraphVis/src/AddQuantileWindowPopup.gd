extends Popup

onready var quantile_value = $"Background/MarginContainer/MarginContainer/VBoxContainer/GridContainer/Panel0/QuantileValue"
onready var quantile_color_value = $"Background/MarginContainer/MarginContainer/VBoxContainer/GridContainer/QuantileColorButton"

func _ready():
	pass

func _on_ApplyButton_pressed():
	if (float(quantile_value.text) < float(0)):
		GlobalVariables.edge_gradients_with_colors[float(0)] = quantile_color_value.color
	elif (float(quantile_value.text) > float(1)):
		GlobalVariables.edge_gradients_with_colors[float(1)] = quantile_color_value.color
	elif (GlobalVariables.edge_gradients_with_colors.has(float(quantile_value.text))):
		pass
	else:
		GlobalVariables.edge_gradients_with_colors[float(quantile_value.text)] = quantile_color_value.color
		GlobalVariables.edge_quantiles_with_colors[float(quantile_value.text)] = quantile_color_value.color
		GlobalVariables.edge_gradients_quantiles_list.push_back(float(quantile_value.text))
		GlobalVariables.edge_gradients_quantiles_list.sort()
		GlobalVariables.probs.sort()
	GlobalSettings.change_quantiles_list()
	GlobalSettings.change_gradient_list(float(quantile_value.text))
	visible = false
