extends MultiMeshInstance2D

func _ready():
	# Create the multimesh.
	multimesh = MultiMesh.new()
	# Set the format first.
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_NONE
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	# Then resize (otherwise, changing the format is not allowed).
	multimesh.instance_count = 10000
	# Maybe not all of them should be visible at first.
	multimesh.visible_instance_count = 1000
	# Set the transform of the instances.
	for i in multimesh.visible_instance_count:
		multimesh.set_instance_transform_2d(i, Transform2D(Basis(), Vector2(i * 20, 0)))

